if Settings.redis.present?
  Sidekiq.configure_server do |config|
    config.redis = { url: "redis://#{Settings.redis.host}:#{Settings.redis.port.to_s}", namespace: "#{Rails.application.class.parent}_#{Rails.env}" }
    # for sidekiq-failures
    config.failures_max_count = false
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: "redis://#{Settings.redis.host}:#{Settings.redis.port.to_s}", namespace: "#{Rails.application.class.parent}_#{Rails.env}" }
  end
end
