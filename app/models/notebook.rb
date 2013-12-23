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
#

class Notebook < ActiveRecord::Base
  # Resque needs a queue
  @queue = :default

  acts_as_paranoid

  STATES = %w[submitted received uploaded processed returned recycled]
  delegate :submitted?, :uploaded?, :returned?, :received?, :recycled?, to: :current_state
  delegate :processed?, to: :current_process_state

  COLORS        = { "01" => "red", "02" => "green", "03" => "tan" }
  PAPER_TYPES   = { "01" => "blank", "02" => "lined", "03" => "dotgrid" }

  #-----------------------------------------------------------------------------
  # Relationships
  #-----------------------------------------------------------------------------

  belongs_to :user
  has_many :events, -> { order 'created_at ASC' }, class_name: "NotebookEvent", dependent: :destroy
  has_many :pages,  -> { order 'index ASC' }, dependent: :destroy

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

  validates :notebook_identifier,
    format: { with: Patterns::NOTEBOOK_IDENTIFIER_PATTERN },
    presence: true,
    uniqueness: { case_sensitive: false }

  #-----------------------------------------------------------------------------
  # Uploaders
  #-----------------------------------------------------------------------------

  mount_uploader :pdf, NotebookPDFUploader

  #-----------------------------------------------------------------------------
  # Callbacks
  #-----------------------------------------------------------------------------

  before_validation :attributes_from_notebook_identifier, if: :notebook_identifier_changed?

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

    # Resque async helper
    # https://github.com/resque/resque/blob/1-x-stable/examples/async_helper.rb
    def perform(id, method, *args)
      find(id).send(method, *args)
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

  def current_state
    (events.last.try(:state) || STATES.first).inquiry
  end

  def current_process_state
    (events.where(scope: :process).last.try(:state) ||  STATES.first).inquiry
  end

  def upload
    events.create! state: "uploaded" if submitted?
  end

  def return
    # A notebook can be return only if it has been uploaded before
    events.create! state: "returned", if ever_uploaded? && !ever_recycled?
  end

  def recycle
    # A notebook can be recycled only if it has been uploaded before
    events.create! state: "recycled", if ever_uploaded? && !ever_returned?
  end

  def process
    events.create! state: "processed", scope: :process if uploaded?
  end

  def process!(reprocess=false)
    PageFiller.new(self).fill_pages(reprocess) do |pages|
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
    def attributes_from_notebook_identifier
      parts = self.class.parse_notebook_identifier(self.notebook_identifier || "")
      self.color              = COLORS[parts[:color]]
      self.paper_type         = PAPER_TYPES[parts[:paper_type]]
      self.carrier_identifier = parts[:carrier_identifier]
    end
end
