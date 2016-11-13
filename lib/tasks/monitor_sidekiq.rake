namespace :monitor_sidekiq do
  desc "check sidekiq process and restart if dead"
  task proccess_check: :environment do
    log_file = "#{Rails.root}/log/restart_sidekiq.log"
    result = `ps aux | grep sidekiq | grep -v 'grep'`

    process_found = false
    result.split("\n").each{|line|
      next if !line.include?('sidekiq 4.1.1')

      process_found = true
      break
    }

    if process_found
      log = Time.now.to_s + ' sidekiq has lived.'
      #`echo "#{log}" >>"#{log_file}"`
      exit
    end

    restart_result = `cd #{Rails.root} && bundle exec sidekiq -d -C config/sidekiq.yml -e production`
    log = Time.now.to_s + ' sidekiq is restarted.'
    `echo "#{log}" >>"#{log_file}"`
    `echo "#{restart_result}" >>"#{log_file}"`
  end

  desc "check sidekiq running and restart if memory leak"
  task running_check: :environment do
    MonitorSidekiq.running_check
  end
end
