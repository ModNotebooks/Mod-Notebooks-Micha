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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notebook_setting do
    name "MyString"
  end
end
