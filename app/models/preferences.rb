# == Schema Information
#
# Table name: preferences
#
#  id         :integer          not null, primary key
#  properties :hstore
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Preferences < ActiveRecord::Base

  #-----------------------------------------------------------------------------
  # Relationships
  #-----------------------------------------------------------------------------

  belongs_to :user
  has_one :address, as: :addressable, dependent: :destroy, validate: false
  store_accessor :properties, :test

  accepts_nested_attributes_for :address, update_only: true

  #-----------------------------------------------------------------------------
  # Validations
  #-----------------------------------------------------------------------------

  validates :user,
    presence: true

  validates_associated :address

  #-----------------------------------------------------------------------------
  # Class Methods
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------

  def address
    super || build_address
  end

end
