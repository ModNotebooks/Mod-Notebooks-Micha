CarrierWave.configure do |config|

  if Rails.env.test?
    config.storage = :file
  else
    config.storage = :fog
  end

  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
  }
  config.fog_directory  = ENV['AWS_BUCKET_NAME']
  config.fog_public     = false
  config.fog_authenticated_url_expiration = 60 * 5 # 5 minutes
end
