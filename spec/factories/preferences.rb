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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :preference, :class => 'Preferences' do
  end
end
