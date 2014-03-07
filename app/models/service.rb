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
#  token           :text
#  secret          :text
#  refresh_token   :text
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

class Service < ActiveRecord::Base

  PROVIDERS = %w(dropbox evernote live_connect)
  DISABLED_REASONS = []

  Unconfigurable = Class.new(ModError)
  InvalidRequest = Class.new(ModError)
  Unauthorized   = Class.new(ModError)

  #-----------------------------------------------------------------------------
  # Relationships
  #-----------------------------------------------------------------------------

  acts_as_paranoid
  belongs_to :user

  #-----------------------------------------------------------------------------
  # Validations
  #-----------------------------------------------------------------------------

  validates :disabled_reason, allow_blank: true, inclusion: { in: lambda { |service|
    service.class::DISABLED_REASONS.map(&:to_s)
  }}

  validates :provider,
    presence: true,
    inclusion: { in: PROVIDERS }

  validates :token,
    presence: true,
    allow_nil: true

  validates :secret,
    presence: true,
    allow_nil: true,
    allow_blank: true

  validates :uid,
    presence: true,
    uniqueness: { case_sensitive: false }


  #-----------------------------------------------------------------------------
  # Scopes
  #-----------------------------------------------------------------------------

  scope :provider, -> (provider) { where(provider: provider) }

  #-----------------------------------------------------------------------------
  # Callbacks
  #-----------------------------------------------------------------------------

  before_destroy :destroy_cleanup

  #-----------------------------------------------------------------------------
  # Class Methods
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------

  def active_model_serializer
    ServiceSerializer
  end

  def with_api(options, &block)
    raise NotImplementedError.new("You must implement #with_api")
  end

  def create_api
    raise NotImplementedError.new("You must implement #create_api")
  end

  def api(options={})
    options.reverse_merge!(force: false)
    @api = nil if options[:force]
    @api ||= create_api
  end

  def syncer(notebook)
    raise NotImplementedError.new("You must implement #syncer")
  end

  PROVIDERS.each do |provider|
    define_method("#{provider}?") do
      self.provider == provider
    end
  end

  # def error!(reason, data={})
  #   period = 1.day
  #   count  = 10
  #
  #   now    = Time.now.to_i
  #   ago    = period.ago.to_i
  #   key    = error_key(reason)
  #
  #   # Remove elements that are old than one period
  #   REDIS.zremrangebyscore(key, 0, ago)
  #   REDIS.zadd(key, now, {time: now, data: data}.to_json)
  #   # Keep the key alive for one period from this error
  #   # If we don't get another error in that period we'll remove the key
  #   REDIS.expire(key, period)
  #
  #   # Disable if we have more than 10 errors for a reason in a given period
  #   disable!(reason, data) if REDIS.zcount(key, ago, now) >= count
  # end

  def destroy_cleanup
    update(token: nil, secret: nil, refresh_token: nil, expires_at: nil)
  end

  # def error_key(reason)
  #   ['services', self.id, 'errors', reason].join(':')
  # end

end
