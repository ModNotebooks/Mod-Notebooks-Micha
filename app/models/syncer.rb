class Syncer
  attr_accessor :service, :notebook

  @queue = :default

  def initialize(service, notebook)
    self.service  = service
    self.notebook = notebook
  end

  def sync; end

  def sync_key(resource)
    self.class.sync_key(service.provider, resource)
  end

  def mark_synced(resource)
    self.class.mark_synced(service.provider, resource)
  end

  def mark_unsynced(resource)
    self.class.mark_unsynced(service.provider, *[resource])
  end

  def needs_sync?(resource)
    true
    self.class.needs_sync?(service.provider, resource)
  end

  def redis
    self.class.redis
  end

  class << self
    def redis
      @@redis ||= Redis::Namespace.new(:syncer, redis: $redis)
    end

    def sync(user_id)
      user = User.find(user_id)

      user.services.each do |service|
        user.notebooks.each do |notebook|
          service.syncer(notebook).sync()
        end
      end
    end

    # Resque async helper
    # https://github.com/resque/resque/blob/1-x-stable/examples/async_helper.rb
    def async(method, *args)
      Resque.enqueue(Syncer, method, *args)
    end

    # Resque async helper
    # https://github.com/resque/resque/blob/1-x-stable/examples/async_helper.rb
    def perform(method, *args)
      send(method, *args)
    end

    def mark_unsynced(service_names, *resources)
      service_names = [service_names] unless service_names.is_a?(Array)

      resources.flatten.each do |r|
        service_names.each do |service|
          key = sync_key(service, r)
          redis.setbit(key, r.id, 0)
        end
      end
    end

    def mark_synced(service_name, resource)
      key = sync_key(service_name, resource)
      redis.setbit(key, resource.id, 1)
    end

    def needs_sync?(service_name, resource)
      key = sync_key(service_name, resource)
      redis.getbit(key, resource.id) == 0 ? true : false
    end

    def sync_key(service_name, resource)
      "#{service_name}:#{resource.class.to_s.downcase.pluralize}"
    end
  end

end
