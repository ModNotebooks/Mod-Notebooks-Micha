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
  include ActiveModel::Transitions

  # Resque needs a queue
  @queue = :default

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
  acts_as_paranoid

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
  # State Machine
  #-----------------------------------------------------------------------------

  state_machine auto_scopes: true, initial: :created do
    state :created
    state :submitted
    state :received
    state :uploaded
    state :processed
    state :returned
    state :recycled

    event :submit, success: :notebook_submitted, timestamp: :submitted_on do
      transitions to: :submitted, from: :created,
        on_transition: :handle_submission,
        guard: lambda { |n| n.user.blank? }
    end

    event :receive, success: :notebook_received, timestamp: :received_on do
      transitions to: :received, from: :submitted
    end

    event :upload, success: :notebook_received, timestamp: :uploaded_on do
      transitions to: :uploaded, from: [:uploaded, :received],
        on_transition: [:handle_upload]
    end

    event :process, success: :notebook_processed, timestamp: :processed_on do
      transitions to: :processed, from: [:processed, :uploaded],
        on_transition: [:process_notebook]
    end

    event :return, success: :notebook_returned, timestamp: :returned_on do
      transitions to: :returned, from: :processed,
        guard: lambda { |n| n.handle_method.inquiry.return? }
    end

    event :recycle, success: :notebook_recycled, timestamp: :recycled_on do
      transitions to: :recycled, from: :processed,
        guard: lambda { |n| n.handle_method.inquiry.recycle? }
    end
  end

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
  end

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------

  def notebook_submitted

  end

  def notebook_received

  end

  def notebook_uploaded

  end

  def notebook_processed

  end

  def notebook_returned

  end

  def notebook_recycled

  end

  def handle_upload(upload)
    update(pdf: upload)
  end

  def handle_submission(user, options)
    options.reverse_merge!(user: user)
    update(options)
  end

  def process_notebook(reprocess = false)
    PageFiller.new(self).fill_pages(reprocess)
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
