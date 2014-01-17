source 'https://rubygems.org'

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
gem 'resque-scheduler', github: 'resque/resque-scheduler', require: 'resque_scheduler'
gem 'resque_mailer'

gem 'strip_attributes'
gem 'active_model_serializers'

gem 'jquery-rails'
gem 'rack-cors', require: 'rack/cors'

gem 'carrierwave'
gem 'fog'
gem 'grim'
gem 'mini_magick'
gem 'doorkeeper', '~> 0.7.0'
gem 'paranoia', '~> 2.0'

gem 'ember-rails'
gem 'ember-source', '1.4.0.beta.2' # or the version you need
gem 'ember-data-source', '1.0.0.beta.5'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'bourbon', '~> 3.2.0.beta.1'
gem 'neat'

group :assets do
  gem 'sass-rails', '~> 4.0.0'
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails', '~> 4.0.0'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'jazz_hands'
  gem 'bullet'
  gem 'quiet_assets'
  # gem 'rack-mini-profiler'
  gem 'annotate'
  gem 'pry-rails'
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
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
