# == Schema Information
#
# Table name: services
#
#  id              :integer          not null, primary key
#  type            :string(255)
#  user_id         :integer
#  provider        :string(255)
#  uid             :string(255)
#  name            :string(255)
#  email           :string(255)
#  nickname        :string(255)
#  token           :binary
#  secret          :binary
#  refresh_token   :binary
#  expires_at      :datetime
#  checked_at      :datetime
#  deleted_at      :datetime
#  delta_cursor    :text
#  meta            :hstore
#  disabled_at     :datetime
#  disabled_reason :string(255)
#  disabled_data   :hstore
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Service do
  pending "add some examples to (or delete) #{__FILE__}"
end
