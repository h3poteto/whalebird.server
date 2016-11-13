# frozen_string_literal: true
namespace :monitor_sidekiq do
  desc "check sidekiq running and restart if memory leak"
  task running_check: :environment do
    MonitorSidekiq.running_check
  end
end
