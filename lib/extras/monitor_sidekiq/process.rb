# frozen_string_literal: true
module MonitorSidekiq
  class Process
    def running?
      result = `ps aux | grep sidekiq | grep -v 'grep'`
      process_found = false
      result.split("\n").each{|line|
        next if !line.include?("sidekiq #{Sidekiq::VERSION}")

        process_found = true
        break
      }
      process_found
    end

    def restart
      restart_result = `cd #{Rails.root} && bundle exec sidekiq -d -C #{MonitorSidekiq::Config.config_file} -e #{Rails.env}`
      MonitorSidekiq::Logging.logger.info "Sidekiq is restarted."
      MonitorSidekiq::Logging.logger.info restart_result
    end
  end
end
