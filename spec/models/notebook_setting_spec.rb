# == Schema Information
#
# Table name: notebook_settings
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  color_code  :string(255)
#  color       :string(255)
#  cover_image :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe NotebookSetting do
  pending "add some examples to (or delete) #{__FILE__}"
end
