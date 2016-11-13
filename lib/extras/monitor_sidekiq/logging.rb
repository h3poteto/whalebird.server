# frozen_string_literal: true
module MonitorSidekiq
  class Logging
    attr_reader :logger

    def initialize
      @logger = Logger.new("#{Rails.root}/log/monitor_sidekiq.log")
      @logger.level = Logger::INFO
    end

    def self.logger
      @logger ||= self.new.logger
    end
  end
end
