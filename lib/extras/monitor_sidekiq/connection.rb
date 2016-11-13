# frozen_string_literal: true
module MonitorSidekiq
  class Connection
    attr_reader :redis, :namespace, :timeout
    def initialize
      @redis = Redis.new(
        host: Settings.redis.host,
        port: Settings.redis.port
      )
      @namespace = "#{Rails.application.class.parent}_#{Rails.env}"
      @timeout = 10
    end

    def prepare
      redis.set("#{namespace}_alive_sidekiq", "0")
    end

    def running?
      redis.get("#{namespace}_alive_sidekiq").to_i.nonzero?
    end

    def alive
      redis.set("#{namespace}_alive_sidekiq", "1")
    end

    def send_sidekiq_signal
      MonitorSidekiqWorker.perform_async
    end

    def wait
      sleep(timeout)
    end

    def stop
      pid = MonitorSidekiq::Config.pid_file
      if File.exist?(pid)
        ::Process.kill("KILL", File.read(pid).to_i)
        MonitorSidekiq::Logging.logger.info "Sidekiq is stopped."
        # 起動はmonit側に任せる
      end
    end
  end
end
