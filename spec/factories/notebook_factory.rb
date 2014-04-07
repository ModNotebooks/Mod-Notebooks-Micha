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
#  meta                :hstore           default({}), not null
#  created_at          :datetime
#  updated_at          :datetime
#  notebook_identifier :string(255)
#  pdf                 :string(255)
#  pages_count         :integer          default(0)
#  deleted_at          :datetime
#  handle_method       :string(255)
#  state               :string(255)
#  submitted_on        :datetime
#  received_on         :datetime
#  uploaded_on         :datetime
#  processed_on        :datetime
#  returned_on         :datetime
#  recycled_on         :datetime
#  available_on        :datetime
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
