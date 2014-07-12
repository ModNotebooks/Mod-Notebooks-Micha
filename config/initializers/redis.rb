if Rails.env.test?
  $redis = Redis.new(db: 1)
else
  $redis = Redis.new(url: (ENV['REDISCLOUD_URL'] || ENV['BOXEN_REDIS_URL'] || 'redis://127.0.0.1:6379'))
end
