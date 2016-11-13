class MonitorSidekiqWorker
  include Sidekiq::Worker

  def perform
    MonitorSidekiq::Connection.new.alive
  end
end
