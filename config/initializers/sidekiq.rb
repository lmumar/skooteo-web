require 'sidekiq/middleware/i18n'

sidekiq_config = Rails.application.config_for 'sidekiq_redis'
sidekiq_redis_url = "redis://#{sidekiq_config['redis_host']}:#{sidekiq_config['redis_port']}/#{sidekiq_config['redis_db']}"

Sidekiq.configure_server do |config|
  config.redis = { url: sidekiq_redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: sidekiq_redis_url }
end
