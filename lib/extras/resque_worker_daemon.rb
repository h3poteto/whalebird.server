# frozen_string_literal: true
class ResqueWorkerDaemon < DaemonSpawn::Base
  def start(_args)
    # 複数のworkerがある場合はカンマ区切りで指定する
    @worker = Resque::Worker.new(Settings.resque.queue)
    @worker.verbose = true
    @worker.work
  end

  def stop
    Teimout.timeout(Settings.resque.stop_timeout) do
      @worker.shutdown
    end
  rescue Timeout::Error => _e
    @worker.shutdown!
  end

  def self.options
    {
      processes: Settings.resque.process, # プロセス数の指定
      working_dir: Rails.root,
      pid_file: File.join(Rails.root, 'tmp', 'pids', 'resque_daemon.pid'),
      log_file: File.join(Rails.root, 'log', 'resque_daemon.log'),
      sync_log: true,
      singleton: true
    }
  end
end
