source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.2'
gem 'pg'
gem 'unicorn'
gem 'redis-rails'

gem 'devise'
gem 'devise_invitable'

gem 'resque', require: 'resque/server'
gem 'resque-loner'
gem 'resque-queue-priority'
gem 'resque-sentry'
gem 'resque-timeout'
gem 'resque-scheduler', require: 'resque_scheduler'
gem 'resque_mailer'

gem 'omniauth'
gem 'omniauth-dropbox'
gem 'omniauth-evernote'
gem 'omniauth-live-connect', github: 'erickreutz/omniauth-live_connect'

gem 'strip_attributes'
gem 'active_model_serializers'

gem 'jquery-rails'
gem 'rack-cors', require: 'rack/cors'

gem 'carrierwave'
# gem 'carrierwave-imageoptimizer'

gem 'fog'
gem 'grim'
gem 'mini_magick'
gem 'doorkeeper', '~> 0.7.0'
gem 'paranoia', '~> 2.0'
gem 'acts_as_list'

gem 'asset_sync'
gem 'ember-rails'
gem 'ember-source', '1.4.0' # or the version you need
gem 'ember-data-source', '1.0.0.beta.6'

gem 'compass-rails', '1.1.0.pre'
gem 'sass-rails', '>= 4.0.0'


gem 'rails_12factor', group: :production

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
