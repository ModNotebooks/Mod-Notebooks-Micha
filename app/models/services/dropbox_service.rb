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

class DropboxService < Service

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------

  def with_api(options={}, &block)
    options.reverse_merge!(on_rescue: [])
    yield(api)
  rescue Dropbox::API::Error::Unauthorized => e
    Raven.capture_exception(e, extra: { service_id: self.id })
    return options[:on_rescue]
  rescue Dropbox::API::Error::StorageQuote => e
    Raven.capture_exception(e, extra: { service_id: self.id })
    return options[:on_rescue]
  rescue Dropbox::API::Error::BadInput => e
    Raven.capture_exception(e, extra: { service_id: self.id })
    return options[:on_rescue]
  rescue Dropbox::API::Error::ConnectionFailed => e
    Raven.capture_exception(e, extra: { service_id: self.id })
    return options[:on_rescue]
  rescue ModError => e
    Raven.capture_exception(e, extra: { service_id: self.id })
    return options[:on_rescue]
  end

  def create_api
    Dropbox::API::Client.new(token: token, secret: secret)
  end

  def syncer(notebook)
    DropboxSyncer.new(self, notebook)
  end
end
