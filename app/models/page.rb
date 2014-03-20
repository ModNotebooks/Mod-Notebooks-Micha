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
#  position    :integer
#

class Page < ActiveRecord::Base

  #-----------------------------------------------------------------------------
  # Relationships
  #-----------------------------------------------------------------------------

  belongs_to :notebook, counter_cache: true
  has_one :user, through: :notebook
  has_many :shares, as: :shareable

  acts_as_paranoid
  acts_as_list scope: :notebook

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
