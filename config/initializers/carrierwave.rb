CarrierWave.configure do |config|

  config.cache_dir = "#{Rails.root}/tmp/uploads"

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
  config.fog_directory  = ENV['FOG_DIRECTORY']
  config.fog_public     = false
  config.fog_authenticated_url_expiration = 60 * 5 # 5 minutes

  # Carrierwave Direct
  config.min_file_size             = 5.kilobytes  # defaults to 1.byte
  config.max_file_size             = 200.megabytes
  config.use_action_status = true
end
