if Settings.redis.present?
  Sidekiq.configure_server do |config|
   config.redis = { url: "redis://#{Settings.redis}", namespace: "#{Rails.application.class.parent}_#{Rails.env}" }
  end

  Sidekiq.configure_client do |config|
   config.redis = { url: "redis://#{Settings.redis}", namespace: "#{Rails.application.class.parent}_#{Rails.env}" }
  end
end
