require 'resque/errors'

class BaseWorker
  include Resque::Plugins::UniqueJob
end
