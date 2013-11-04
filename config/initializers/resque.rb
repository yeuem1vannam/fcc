Dir[File.join(Rails.root, 'app', 'workers', '*.rb')].each{|file| require file}
redis_conf_path = Rails.root.join("config/redis", "#{Rails.env}.conf")
redis_conf = File.read(redis_conf_path)
port = /port.(\d+)/.match(redis_conf)[1]
host_redis = /host_redis.(\S+)/.match(redis_conf)[1]
Resque.redis = Redis.new(host: host_redis, port: port)
