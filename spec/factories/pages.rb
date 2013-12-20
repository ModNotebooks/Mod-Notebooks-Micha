# == Schema Information
#
# Table name: pages
#
#  id          :integer          not null, primary key
#  number      :integer
#  image       :string(255)
#  meta        :hstore           default({})
#  notebook_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    number 1
    image "MyString"
    meta ""
    notebook nil
  end
end
