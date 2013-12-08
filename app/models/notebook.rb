class Notebook < ActiveRecord::Base

  ##
  # Associations
  ##
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

  ##
  # Instance Methods
  ##
end
