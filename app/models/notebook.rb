# == Schema Information
#
# Table name: notebooks
#
#  id                  :integer          not null, primary key
#  name                :string(255)
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

  validates :carrier_identifier,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :handle_method,
    presence: true,
    inclusion: { in: HANDLE_METHOD }

  validates :notebook_identifier,
    presence: true,
    uniqueness: { case_sensitive: false }

  validate :notebook_identifier_is_valid

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
    # Resque async helper
    # https://github.com/resque/resque/blob/1-x-stable/examples/async_helper.rb
    def perform(id, method, *args)
      find(id).send(method, *args)
    end
  end

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------

  def code
    NotebookCode.new(notebook_identifier)
  end

  def color
    code.color
  end

  def paper
    code.paper
  end

  def cover_image
    code.cover_image
  end

  def name
    super || "Untitled"
  end
  
  def pdf_url
    if pdf.url == nil
      nil
    else
      Bitly.client.shorten(pdf.url).short_url
    end
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
    def attributes_from_notebook_identifier
      self.carrier_identifier = code.identifier
    end

    def notebook_identifier_is_valid
      errors.add(:notebook_identifier, "is in wrong format") unless code.valid?
    end

    def default_handle_method
      self.handle_method ||= "recycle"
    end
end
