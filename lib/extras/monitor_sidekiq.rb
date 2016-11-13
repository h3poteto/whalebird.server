# frozen_string_literal: true
module MonitorSidekiq
  def self.connection_check
    monitor = MonitorSidekiq::Connection.new
    monitor.prepare
    monitor.send_sidekiq_signal
    monitor.wait
    unless monitor.running?
      MonitorSidekiq::Logging.logger.warn "Sidekiq worker is not running."
      monitor.stop
    end
  end
end
