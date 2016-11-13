# -*- coding: utf-8 -*-
# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# 出力先のログファイルの指定
set :output, {:error => 'log/crontab.err.log', :standard => 'log/crontab.log'}
# ジョブの実行環境の指定
set :environment, :production
env :PATH, ENV['PATH']
job_type :rails4_runner, "cd :path && bin/rails runner -e :environment :task :output"


every 1.day, :at => '23:00 pm' do
  rake "image:clean"
end

every '*/5 * * * *' do
  rails4_runner "MonitorSidekiq.check_and_restart"
end

every '21 21 * * *' do
  rake "userstream:restart"
end
