# frozen_string_literal: true
class MonitorSidekiqWorker
  include Sidekiq::Worker

  def perform
    MonitorSidekiq::Connection.new.alive
  end
end
