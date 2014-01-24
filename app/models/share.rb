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

class Share < ActiveRecord::Base
  belongs_to :shareable, polymorphic: true

  before_create :generate_token

  private
    def generate_token
      self.token = SecureRandom.hex(8)
    end
end
