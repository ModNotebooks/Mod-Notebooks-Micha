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
#  meta                :hstore
#  created_at          :datetime
#  updated_at          :datetime
#  notebook_identifier :string(255)
#

class Notebook < ActiveRecord::Base

  STATES = %w[with_user submitted uploaded processed]
  delegate :with_user?, :submitted?, :uploaded?, :processed?, to: :current_state

  COLORS      = { "01" => "red", "02" => "green", "03" => "tan" }
  PAPER_TYPES = { "01" => "blank", "02" => "lined", "03" => "dotgrid" }

  ##
  # Associations
  ##
  has_many :events, -> { order 'created_at ASC' }, class_name: "NotebookEvent"
  belongs_to :user

  ##
  # Validations
  ##

  # to_s so validations pass
  validates :color,
    presence: true,
    inclusion: { in: COLORS.values }

  # to_s so validations pass
  validates :paper_type,
    presence: true,
    inclusion: { in: PAPER_TYPES.values }

  validates :carrier_identifier,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :notebook_identifier,
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

    def parse_notebook_identifier(identifier)
      parts = identifier.split('-')

      if parts.count == 3
        { color: COLORS[parts[0]], paper_type: PAPER_TYPES[parts[1]], carrier_identifier: parts[2] }
      else
        {}
      end
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
