class Notebook < ActiveRecord::Base

  STATES = %w[with_user submitted uploaded processed]
  delegate :with_user?, :submitted?, :uploaded?, :processed?, to: :current_state

  ##
  # Associations
  ##
  has_many :events, class_name: "NotebookEvent"
  belongs_to :user

  ##
  # Validations
  ##
  validates :color,
    presence: true,
    length: { is: 2 },
    numericality: true

  validates :paper_type,
    presence: true,
    length: { is: 2 },
    numericality: true

  validates :carrier_identifier,
    presence: true,
    uniqueness: { case_sensitive: false }

  ##
  # Class Methods
  ##
  class << self
    def with_user_notebooks
      join(:events).merge NotebookEvent.with_last_state("processed")
    end

    def submitted_notebooks
      join(:events).merge NotebookEvent.with_last_state("processed")
    end

    def uploaded_notebooks
      join(:events).merge NotebookEvent.with_last_state("processed")
    end

    def processed_notebooks
      join(:events).merge NotebookEvent.with_last_state("processed")
    end
  end

  ##
  # Instance Methods
  ##
  def current_state
    (events.last.try(:state) || STATES.first).inquiry
  end

  def submit
    events.create! state: "submitted" if with_user?
  end

  def upload
    events.create! state: "uploaded" if submitted?
  end

  def process
    events.create! state: "processed" if submitted?
  end

end
