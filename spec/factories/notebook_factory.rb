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

require 'faker'

FactoryGirl.define do
  factory :notebook do
    name "My Notebook"
    sequence(:notebook_identifier) do |n|
      "#{Notebook::COLORS.keys.sample}-#{Notebook::PAPER_TYPES.keys.sample}-#{Faker::Number.number(6)}#{n}"
    end
  end
end
