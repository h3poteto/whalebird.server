# frozen_string_literal: true
namespace :monitor_sidekiq do
  desc "check sidekiq process and restart"
  task process_check: :environment do
    MonitorSidekiq.process_check
  end
  desc "check sidekiq either working or dead and restart"
  task working_check: :environment do
    MonitorSidekiq.working_check
  end
end
