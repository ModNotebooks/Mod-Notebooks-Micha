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

require 'spec_helper'

describe Page do
  pending "add some examples to (or delete) #{__FILE__}"
end
