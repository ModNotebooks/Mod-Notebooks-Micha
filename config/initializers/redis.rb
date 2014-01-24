if Rails.env.test?
  $redis = Redis.new(db: 1)
else
  $redis = Redis.new(url: (ENV['REDIS_URL'] || 'redis://127.0.0.1:6379'))
end
