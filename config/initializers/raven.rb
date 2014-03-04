require 'raven'

Raven.configure do |config|
  config.current_environment = Rails.env.to_s
  config.environments = %w(production staging)
  config.dsn = ENV['SENTRY_DSN']
end
