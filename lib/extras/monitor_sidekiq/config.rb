# frozen_string_literal: true
module MonitorSidekiq
  module Config
    def self.pid_file
      "#{Rails.root}/tmp/pids/sidekiq.pid"
    end

    def self.config_file
      "#{Rails.root}/config/sidekiq.yml"
    end
  end
end
