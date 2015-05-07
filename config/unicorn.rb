# -*- coding: utf-8 -*-
# ワーカーの数
worker_processes 2

shared_path = "/srv/www/whalebird.server/shared/"
current_path = "/srv/www/whalebird.server/current"

# ソケット経由で通信する
listen File.expand_path('tmp/sockets/unicorn.sock', shared_path)
pid File.expand_path('tmp/pids/unicorn.pid', shared_path)

# ログ
stderr_path File.expand_path('log/unicorn.log', shared_path)
stdout_path File.expand_path('log/unicorn.log', shared_path)

# capistrano 用に RAILS_ROOT を指定
working_directory current_path

# ダウンタイムなくす
preload_app true

timeout 45


before_fork do |server, worker|
  ENV['BUNDLE_GEMFILE'] = File.expand_path('Gemfile', current_path)
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
