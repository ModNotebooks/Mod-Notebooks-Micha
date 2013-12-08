# == Schema Information
#
# Table name: notebooks
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  color              :string(255)
#  paper_type         :string(255)
#  carrier_identifier :string(255)
#  user_id            :integer
#  meta               :hstore
#  created_at         :datetime
#  updated_at         :datetime
#

require 'faker'

FactoryGirl.define do
  factory :notebook do
    name "My Notebook"
    color Notebook::COLORS.values.sample
    paper_type Notebook::PAPER_TYPES.values.sample
    carrier_identifier Faker::Number.number(6)
  end
end
