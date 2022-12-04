redis_port   = Settings.redis.port
redis_host   = Settings.redis.host
redis_url    = "redis://#{redis_host}:#{redis_port}"

SQ_ERR_LOGGER = Logger.new("#{ Rails.root }/log/sidekiq.errors.log")

puts "Sidekiq: will try to connect to Redis: #{redis_url}".cyan

Sidekiq.configure_client do |config|
  config.redis = {
    url: redis_url
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: redis_url
  }
end

Sidekiq.configure_server do |config|
  config.error_handlers << Proc.new do |ex,context|
    # ExceptionNotifier.notify_exception(ex, data: { sidekiq: context })
    SQ_ERR_LOGGER.error "#{ex}\n#{context}\n\n"
  end
end
