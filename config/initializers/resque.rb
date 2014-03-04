require 'resque/failure/multiple'
require 'resque/failure/redis'

require 'resque-sentry'
require 'resque_scheduler'
require 'resque_scheduler/server'
require 'resque-queue-priority-server'

Resque.redis = $redis
Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Sentry]
Resque::Failure.backend = Resque::Failure::Multiple
Resque.inline = ENV['RESQUE_INLINE'] || false

Resque::Plugins::Timeout.timeout = ENV['RESQUE_TERM_TIMEOUT'].try(:to_i) || 600
