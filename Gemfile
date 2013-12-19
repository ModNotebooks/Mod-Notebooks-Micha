source 'https://rubygems.org'

gem 'rails', '4.0.2'
gem 'pg'
gem 'unicorn'
gem 'redis-rails'

gem 'devise'
gem 'devise_invitable'

gem 'resque', require: 'resque/server'
gem 'resque-sentry'
gem 'resque-scheduler', github: 'resque/resque-scheduler', require: 'resque_scheduler'
gem 'resque_mailer'

gem 'strip_attributes'
gem 'active_model_serializers'

gem 'jquery-rails'
gem 'rack-cors', require: 'rack/cors'

gem 'carrierwave'
gem 'fog'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

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
