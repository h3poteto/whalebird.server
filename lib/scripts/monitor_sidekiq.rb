# restart if sidekiq has died.
#
# run every 1 minute.
# */1 * * * * /usr/bin/ruby [path]/restart_sidekiq.rb

class MonitorSidekiq
  def self.check_and_restart
    log_file = "#{Rails.root}/log/restart_sidekiq.log"
    result = `ps aux | grep sidekiq | grep -v 'grep'`

    process_found = false
    result.split("\n").each{|line|
      next if !line.include?('sidekiq 3.2.6')

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
end
