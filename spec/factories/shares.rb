# == Schema Information
#
# Table name: shares
#
#  id             :integer          not null, primary key
#  token          :string(255)
#  shareable_id   :integer
#  shareable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :share do
    token "MyString"
  end
end
