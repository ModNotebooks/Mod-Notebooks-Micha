# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  meta                   :hstore           default({}), not null
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  invitation_token       :string(60)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  admin                  :boolean          default(FALSE)
#

class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable #, :invitable

  #-----------------------------------------------------------------------------
  # Relationships
  #-----------------------------------------------------------------------------

  has_many :notebooks, dependent: :nullify
  has_many :pages, through: :notebooks
  has_many :notebook_shares, through: :notebooks, source: :shares
  has_many :page_shares, through: :pages, source: :shares
  has_one  :preferences, dependent: :destroy

  #-----------------------------------------------------------------------------
  # Validations
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Class Methods
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------

  def preferences
    super || build_preferences
  end

end
