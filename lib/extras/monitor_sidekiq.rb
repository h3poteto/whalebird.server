# frozen_string_literal: true
module MonitorSidekiq
  def self.working_check
    monitor = MonitorSidekiq::Connection.new
    monitor.prepare
    monitor.send_sidekiq_signal
    monitor.wait
    unless monitor.running?
      MonitorSidekiq::Logging.logger.warn "Sidekiq is not working."
      monitor.stop
    end
  end

  def self.process_check
    monitor = MonitorSidekiq::Process.new
    unless monitor.running?
      MonitorSidekiq::Logging.logger.warn "Sidekiq process is not running."
      monitor.restart
    end
  end
end
