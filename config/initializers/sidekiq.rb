# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}",
    namespace: "#{Rails.application.class.parent}_#{Rails.env}"
  }
  # for sidekiq-failures
  config.failures_max_count = false
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}",
    namespace: "#{Rails.application.class.parent}_#{Rails.env}"
  }
end
