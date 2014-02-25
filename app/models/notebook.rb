# == Schema Information
#
# Table name: notebooks
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  color               :string(255)
#  paper_type          :string(255)
#  carrier_identifier  :string(255)
#  user_id             :integer
#  meta                :hstore           default({}), not null
#  created_at          :datetime
#  updated_at          :datetime
#  notebook_identifier :string(255)
#  pdf                 :string(255)
#  pages_count         :integer          default(0)
#  deleted_at          :datetime
#  handle_method       :string(255)
#

class Notebook < ActiveRecord::Base
  # Resque needs a queue
  @queue = :default

  acts_as_paranoid

  STATES = %w[submitted received uploaded processed returned recycled]
  delegate :submitted?, :uploaded?, :returned?, :received?, :recycled?, to: :current_state
  delegate :processed?, to: :current_process_state

  COLORS        = { "01" => "gray" }
  PAPER_TYPES   = { "01" => "plain", "02" => "lined", "03" => "dotgrid" }
  HANDLE_METHOD = ["return", "recycle"]

  #-----------------------------------------------------------------------------
  # Relationships
  #-----------------------------------------------------------------------------

  belongs_to :user
  has_many :events, -> { order 'created_at ASC' }, class_name: "NotebookEvent", dependent: :destroy
  has_many :pages,  -> { order("position ASC") }, dependent: :destroy
  has_many :shares, as: :shareable

  #-----------------------------------------------------------------------------
  # Validations
  #-----------------------------------------------------------------------------

  validates :color,
    presence: true,
    inclusion: { in: COLORS.values }

  validates :paper_type,
    presence: true,
    inclusion: { in: PAPER_TYPES.values }

  validates :carrier_identifier,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :handle_method,
    presence: true,
    inclusion: { in: HANDLE_METHOD }

  validates :notebook_identifier,
    format: { with: Patterns::NOTEBOOK_IDENTIFIER_PATTERN },
    presence: true,
    uniqueness: { case_sensitive: false }

  #-----------------------------------------------------------------------------
  # Scopes
  #-----------------------------------------------------------------------------

  scope :reserved, -> { where('user_id IS NOT ?', nil) }
  scope :unreserved, -> { where('user_id IS ?', nil) }

  #-----------------------------------------------------------------------------
  # Uploaders
  #-----------------------------------------------------------------------------

  mount_uploader :pdf, NotebookPDFUploader

  #-----------------------------------------------------------------------------
  # Callbacks
  #-----------------------------------------------------------------------------

  before_validation :attributes_from_notebook_identifier, if: :notebook_identifier_changed?
  before_validation :default_handle_method, on: :create

  #-----------------------------------------------------------------------------
  # Class Methods
  #-----------------------------------------------------------------------------

  class << self
    def submitted_notebooks
      join(:events).where state_query("submitted")
    end

    def uploaded_notebooks
      joins(:events).where state_query('uploaded')
    end

    def processed_notebooks
      joins(:events).where state_query('processed', :process)
    end

    def parse_notebook_identifier(identifier = "")
      parts = identifier.split('-')

      if parts.count == 3
        { color: parts[0], paper_type: parts[1], carrier_identifier: parts[2] }
      else
        {}
      end
    end

    def generate(color, paper, count=100)
      color = COLORS.invert[color.to_s]
      paper = PAPER_TYPES.invert[paper.to_s]

      if paper && color
        notebook_identifiers = (0...count).collect { generate_notebook_identifier(color, paper) }
        create(notebook_identifiers.collect { |nid| { notebook_identifier: nid } })
        notebook_identifiers
      end
    end

    # Resque async helper
    # https://github.com/resque/resque/blob/1-x-stable/examples/async_helper.rb
    def perform(id, method, *args)
      find(id).send(method, *args)
    end

    def generate_notebook_identifier(color, paper)
      "#{color}-#{paper}-#{generate_carrier_identifier}"
    end

    def generate_carrier_identifier
      loop do
        identifier = SecureRandom.hex(3)
        break identifier unless Notebook.exists?(carrier_identifier: identifier)
      end
    end

    private
      def state_query(name = "", scope = :default)
        query = <<-SQL
          notebook_events.id IN (SELECT MAX(id)
            FROM notebook_events
            GROUP BY notebook_id) AND state = '#{name}' AND scope = '#{scope}'
        SQL
      end
  end

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------

  def ever_uploaded?
    events.where(state: :uploaded).exists?
  end

  def ever_returned?
    events.where(state: :returned).exists?
  end

  def ever_recycled?
    events.where(state: :recycled).exists?
  end

  def current_state_at
    events.last.try(:created_at) || created_at
  end

  def current_state
    (events.last.try(:state) || STATES.first).inquiry
  end

  def current_process_state_at
    events.where(scope: :process).last.try(:created_at)
  end

  def current_process_state
    (events.where(scope: :process).last.try(:state) ||  STATES.first).inquiry
  end

  def upload
    events.create! state: "uploaded" if submitted?
  end

  def return
    # A notebook can be return only if it has been uploaded before
    if ever_uploaded? && !ever_recycled? && handle_method == "return"
      events.create! state: "returned"
    end
  end

  def recycle
    # A notebook can be recycled only if it has been uploaded before
    if ever_uploaded? && !ever_returned? && handle_method == "recycle"
      events.create! state: "recycled"
    end
  end

  def process
    events.create! state: "processed", scope: :process if uploaded?
  end

  def process!(reprocess=false)
    PageFiller.new(self).fill_pages(reprocess) do |pages, filler|
      process
      pages
    end
  end

  # Resque async helper
  # https://github.com/resque/resque/blob/1-x-stable/examples/async_helper.rb
  def async(method, *args)
    Resque.enqueue(Notebook, id, method, *args)
  end


  private
    def default_handle_method
      self.handle_method ||= "recycle"
    end

    def attributes_from_notebook_identifier
      parts = self.class.parse_notebook_identifier(self.notebook_identifier || "")
      self.color              = COLORS[parts[:color]]
      self.paper_type         = PAPER_TYPES[parts[:paper_type]]
      self.carrier_identifier = parts[:carrier_identifier]
    end
end
