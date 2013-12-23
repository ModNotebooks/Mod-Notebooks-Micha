class Share < ActiveRecord::Base
  belongs_to :shareable, polymorphic: true

  before_create :generate_token

  private
    def generate_token
      self.token = SecureRandom.hex(4)
    end
end
