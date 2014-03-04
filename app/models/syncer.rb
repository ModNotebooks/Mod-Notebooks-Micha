class Syncer
  OwnershipError = Class.new(ModError)
  UnsubmittedNotebook = Class.new(ModError)

  attr_accessor :service, :notebook

  def initialize(service, notebook)
    if service.user.id != notebook.try(:user).try(:id)
      raise OwnershipError.new("service user is different from notebook user")
    end
    self.service = service
    self.notebook = notebook
  end

  def sync; end

  class << self
    def needs_sync(*resources)
      resources.flatten.each do |r|
        key = sync_key(r)
        redis.setbit(key, r.id, 0)
      end
    end

    def sync_key(service, resource)
      "#{service}:#{ActiveModel::Naming.plural(resource)}"
    end

    def redis
      @@redis ||= Redis::Namespace.new(:syncing, redis: $redis)
    end

    def mark_as_synced(service, resource)
      key = sync_key(service, resource)
      redis.setbit(key, resource.id, 1)
    end

    def needs_sync?(service, resource)
      key = sync_key(service, resource)
      redis.getbit(key, resource.id) === 0 ? true : false
    end
  end

  protected
    def redis
      class.redis
    end

    def needs_sync?(resource)
      class.needs_sync?(service, resource)
    end

    def mark_as_synced(resource)
      class.mark_as_synced(service, resource)
    end

    def sync_key(resource)
      class.sync_key(service, resource)
    end
end
