# == Schema Information
#
# Table name: pages
#
#  id          :integer          not null, primary key
#  index       :integer
#  image       :string(255)
#  meta        :hstore           default({})
#  notebook_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  deleted_at  :datetime
#

class Page < ActiveRecord::Base
  acts_as_paranoid

  store_accessor :meta, :image_secure_token

  #-----------------------------------------------------------------------------
  # Relationships
  #-----------------------------------------------------------------------------

  belongs_to :notebook, counter_cache: true
  has_one :user, through: :notebook
  has_many :shares, as: :shareable

  #-----------------------------------------------------------------------------
  # Validations
  #-----------------------------------------------------------------------------

  validates :index,
    presence: true,
    numericality: true,
    uniqueness: { scope: :notebook_id }

  #-----------------------------------------------------------------------------
  # Uploaders
  #-----------------------------------------------------------------------------

  mount_uploader :image, PageUploader

end
