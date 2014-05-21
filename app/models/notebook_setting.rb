# == Schema Information
#
# Table name: notebook_settings
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  color_code  :string(255)
#  color       :string(255)
#  cover_image :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class NotebookSetting < ActiveRecord::Base

  #-----------------------------------------------------------------------------
  # Relationships
  #-----------------------------------------------------------------------------

  store_accessor :meta, :cover_image_width, :cover_image_height

  mount_uploader :cover_image, CoverImageUploader

  #-----------------------------------------------------------------------------
  # Validations
  #-----------------------------------------------------------------------------

  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :color_code,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :color,
    presence: true,
    format: { with: Patterns::HEX_COLOR }

  validates :cover_image_width,
    allow_blank: true,
    numericality: { equal_to: 380 }

  validates :cover_image_height,
    allow_blank: true,
    numericality: { equal_to: 540 }
end
