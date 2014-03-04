class Syncer
  attr_accessor :service, :notebook

  def initialize(service, notebook)
    self.service  = service
    self.notebook = notebook
  end

  def perform; end

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
    self.class.needs_sync?(service.provider, resource)
  end

  def redis
    self.class.redis
  end

  class << self
    def redis
      @@redis ||= Redis::Namespace.new(:syncer, redis: $redis)
    end

    def sync(user)
      user.notebooks.each do |notebook|
        user.services.each do |service|
          service.syncer(notebook).perform()
        end
      end
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
      redis.getbit(key, resource.id) === 0 ? true : false
    end

    def sync_key(service_name, resource)
      "#{service_name}:#{ActiveModel::Naming.plural(resource)}"
    end
  end

end
