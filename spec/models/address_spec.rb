# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  addressable_id   :integer
#  addressable_type :string(255)
#  name             :string(255)
#  line_1           :string(255)
#  line_2           :string(255)
#  city             :string(255)
#  region           :string(255)
#  postal_code      :string(255)
#  country          :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Address do
  pending "add some examples to (or delete) #{__FILE__}"
end
