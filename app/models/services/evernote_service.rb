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

class EvernoteService < Service

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------

  def with_api(options={}, &block)
    options.reverse_merge!(on_rescue: [])
    yield(api)
  rescue Evernote::EDAM::Error::EDAMUserException => e
    Raven.capture_exception(e, extra: { service_id: self.id })
    return options[:on_rescue]
  rescue Evernote::EDAM::Error::EDAMNotFoundException => e
    Raven.capture_exception(e, extra: { service_id: self.id })
    return options[:on_rescue]
  rescue Evernote::EDAM::Error::EDAMSystemException => e
    Raven.capture_exception(e, extra: { service_id: self.id })
    return options[:on_rescue]
  end

  def create_api
    EvernoteOAuth::Client.new(
      token: token,
      consumer_key: ENV['EVERNOTE_KEY'],
      consumer_secret: ENV['EVERNOTE_SECRET'],
      sandbox: !(Rails.env.production? || Rails.env .staging?)
    )
  end

  def syncer(notebook)
    EvernoteSyncer.new(self, notebook)
  end

end
