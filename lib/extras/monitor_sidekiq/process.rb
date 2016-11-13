# frozen_string_literal: true
module MonitorSidekiq
  class Process
    def running?
      result = `ps aux | grep sidekiq | grep -v 'grep'`
      result.split("\n").any?{ |line| line.include?("sidekiq #{Sidekiq::VERSION}") }
    end

    def restart
      restart_result = `cd #{Rails.root} && bundle exec sidekiq -d -C #{MonitorSidekiq::Config.config_file} -e #{Rails.env}`
      MonitorSidekiq::Logging.logger.info "Sidekiq is restarted."
      MonitorSidekiq::Logging.logger.info restart_result
    end
  end
end
