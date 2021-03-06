source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.4'
gem 'pg'
gem 'unicorn'
gem 'redis-rails'

gem 'devise'
gem 'devise_invitable'

gem 'sentry-raven', git: 'https://github.com/getsentry/raven-ruby.git'
gem 'newrelic_rpm'
gem 'skylight'

gem 'resque', require: 'resque/server'
gem 'resque-scheduler', require: 'resque_scheduler'
gem 'resque-loner'
gem 'resque-queue-priority'
gem 'resque-sentry'
gem 'resque-timeout'
gem 'resque-web', require: 'resque_web'
gem 'resque_mailer'

gem 'omniauth'
gem 'omniauth-dropbox'
gem 'omniauth-evernote'
gem 'omniauth-live-connect', github: 'erickreutz/omniauth-live_connect'

gem 'transitions', require: ['transitions', 'active_model/transitions']

gem 'multipart-post', github: 'nicksieger/multipart-post', require: 'net/http/post/multipart'
gem 'httparty'

gem 'strip_attributes'
gem 'active_model_serializers'

gem 'kaminari'
gem 'textacular', '~> 3.0'

gem 'jquery-rails'
gem 'rack-cors', require: 'rack/cors'

gem 'carrierwave'
gem 'carrierwave_direct', github: 'erickreutz/carrierwave_direct'
# gem 'carrierwave-imageoptimizer'
gem 'blitline', github: 'erickreutz/blitline', branch: 'group_completion_job_id'

gem 'google-api-client'
gem 'dropbox-api'
gem 'evernote_oauth' # This include the SDK

gem 'fog'
gem 'grim'
gem 'mini_magick'
gem 'doorkeeper', '~> 1.0.0'
gem 'paranoia', '~> 2.0'
gem 'acts_as_list'

gem 'asset_sync'
gem 'ember-rails'
gem 'ember-source', '1.4.0' # or the version you need
gem 'ember-data-source', '1.0.0.beta.6'

gem 'compass-rails', '1.1.7'
gem 'compass', '1.0.0.alpha.18'
gem 'sass-rails', '>= 4.0.0'
gem 'sass', '~> 3.3.3'

gem 'rails_12factor', group: :production

gem 'unf'

gem 'bitly'

gem 'dotenv-rails', '~> 2.1', :groups => [:development, :test]

group :assets do
  # gem 'sass-rails', '>= 4.0.0'
  gem 'uglifier', '>= 1.3.0'
  # gem 'compass-rails', '1.1.0.pre'
end

group :development, :staging do
  gem 'better_errors'
  gem 'binding_of_caller'
  # gem 'rack-mini-profiler'
  gem 'pry-rails'
end

group :development do
  gem 'jazz_hands'
  gem 'bullet'
  gem 'quiet_assets'
  gem 'annotate'
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
  gem 'letter_opener'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 3.0.0.beta'
end

group :test do
  gem 'faker'
  gem 'database_cleaner'
  gem 'shoulda'
end
