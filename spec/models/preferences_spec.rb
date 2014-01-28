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

require 'spec_helper'

describe Preferences do
  pending "add some examples to (or delete) #{__FILE__}"
end
