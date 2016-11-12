# frozen_string_literal: true
if Settings.redis.present?
  Resque.redis = "redis://#{Settings.redis}"
  Resque.redis.namespace = "#{Rails.application.class.parent}_#{Rails.env}"
  Resque.logger = Logger.new(Rails.root.join("log", "resque.log"))
end
