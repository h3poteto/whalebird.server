# restart if sidekiq has died.
#
# run every 1 minute.
# */1 * * * * /usr/bin/ruby [path]/restart_sidekiq.rb

log_file = '/srv/www/whalebird.server/log/restart_sidekiq.log'
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

restart_result = `cd /srv/www/whalebird.server && bundle exec sidekiq -d -C config/sidekiq.yml -e production`
log = Time.now.to_s + ' sidekiq is restarted.'
`echo "#{log}" >>"#{log_file}"`
`echo "#{restart_result}" >>"#{log_file}"`
