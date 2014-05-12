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
#  state               :string(255)
#  submitted_on        :datetime
#  received_on         :datetime
#  uploaded_on         :datetime
#  processed_on        :datetime
#  returned_on         :datetime
#  recycled_on         :datetime
#  available_on        :datetime
#

class Notebook < ActiveRecord::Base
  include ActiveModel::Transitions
  include Blitline::NotebookHelper

  # Resque needs a queue
  @queue = :default

  COLORS        = { "01" => "gray", "02" => "red", "03" => "black" }
  PAPER_TYPES   = { "01" => "plain", "02" => "lined", "03" => "dotgrid" }
  HANDLE_METHOD = ["return", "recycle"]

  store_accessor :meta, :evernote_guid, :dropbox_folder_rev

  #-----------------------------------------------------------------------------
  # Relationships
  #-----------------------------------------------------------------------------

  belongs_to :user
  has_many :pages, -> { order("position ASC") }, dependent: :destroy
  has_many :shares, as: :shareable

  acts_as_paranoid
  paginates_per 50
  max_paginates_per 100

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

  state_machine initial: :created, auto_scopes: true do
    state :created
    state :submitted
    state :uploaded
    state :processed
    state :available

    event :submit, success: :notebook_submitted, timestamp: :submitted_on do
      transitions to: :submitted, from: :created,
        on_transition: :handle_submission,
        guard: lambda { |n, user, options| n.user.blank? }
    end

    event :upload, success: :notebook_uploaded, timestamp: :uploaded_on do
      transitions to: :uploaded, from: [:uploaded, :submitted, :processed, :available],
        on_transition: [:handle_upload]
    end

    event :process, success: :notebook_processed, timestamp: :processed_on do
      transitions to: :processed, from: [:processed, :uploaded, :available],
        on_transition: [:process_notebook]
    end

    event :process_failed do
      transitions to: :uploaded, from: :processed
    end

    event :available, success: :notebook_available, timestamp: :available_on do
      transitions to: :available, from: :processed
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
        break identifier unless Notebook.with_deleted.exists?(carrier_identifier: identifier)
      end
    end
  end

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------

  def name
    super || "Untitled"
  end

  def can_return_or_recycle?
    !available_transitions.include?(:submit)
  end

  def return!
    if !returned? && !recycled? && handle_method.inquiry.return?
      update(returned_on: DateTime.now)
      notebook_returned
      true
    else
      false
    end
  end

  def returned?
    returned_on.present?
  end

  def notebook_returned
    NotebooksMailer.notebook_returned(user.id, id).deliver
  end

  def recycle!
    if !returned? && !recycled? && handle_method.inquiry.recycle?
      update(recycled_on: DateTime.now)
      notebook_recycled
      true
    else
      false
    end
  end

  def recycled?
    recycled_on.present?
  end

  def pend!
    if returned? || recycled?
      !!update(recycled_on: nil, returned_on: nil)
    else
      false
    end
  end

  def notebook_recycled; end

  def notebook_submitted
    NotebooksMailer.notebook_submitted(id).deliver
  end

  def notebook_uploaded; end

  def notebook_processed; end

  def notebook_available
    NotebooksMailer.notebook_available(user.id, id).deliver
  end

  def handle_upload(upload)
    upload.is_a?(String) ? update_columns(pdf: upload) : update(pdf: upload)
  end

  def handle_submission(user, options = {})
    options.reverse_merge!(user: user)
    update(options)
  end

  def process_notebook
    Blitline::NotebookPDF.process(self)
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
