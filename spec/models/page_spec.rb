# == Schema Information
#
# Table name: pages
#
#  id          :integer          not null, primary key
#  index       :integer
#  image       :string(255)
#  meta        :hstore           default({})
#  notebook_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  deleted_at  :datetime
#  position    :integer
#

require 'spec_helper'

describe Page do
  pending "add some examples to (or delete) #{__FILE__}"
end
