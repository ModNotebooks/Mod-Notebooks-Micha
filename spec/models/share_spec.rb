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

require 'spec_helper'

describe Share do
  pending "add some examples to (or delete) #{__FILE__}"
end
