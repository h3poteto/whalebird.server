# coding: utf-8
class UserstreamWorker
  include Shoryuken::Worker
  shoryuken_options queue: 'loop', auto_delete: true, retry_intervals: (0...25).map {|i| 10}

  def perform(sqs_msg, user_id)
    sqs_msg.delete
    @user = User.find(user_id.to_i)
    p @user.name

    if !@user.user_setting.notification? || @user.user_setting.device_token.blank?
      @user.update_attributes!(userstream: false)
      p "stop #{@user.name}"
      return true
    end
    client = Twitter::Streaming::Client.new do |config|
      config.consumer_key = ENV["TWITTER_CLIENT_ID"]
      config.consumer_secret = ENV["TWITTER_CLIENT_SECRET"]
      config.access_token = @user.oauth_token
      config.access_token_secret = @user.oauth_token_secret
    end

    ## これの対応待ち一次対応：https://github.com/sferik/twitter/issues/641
    begin
      ## read timeline
      client.user do |status|
        ## notificationによりタスク終了
        user = User.find(user_id)
        if !user.user_setting.notification? || user.user_setting.device_token.blank?
          user.update_attributes!(userstream: false)
          p "stop #{user.name}"
          return true
        end

        case status
        when Twitter::Tweet
          if (status.text.index("RT") == 0 || status.text.index("QT") == 0) && status.user.screen_name != user.screen_name && status.text.include?("@" + user.screen_name)
            if user.user_setting.retweet?
              screen_name = status.user.screen_name
              message = "@" + screen_name + "さんがRTしました"
              user.send_notification(message, "retweet", status)
              p "sent retweet push: #{user.screen_name}"
            end
          elsif status.user.screen_name != user.screen_name && status.text.include?("@" + user.screen_name)
            if user.user_setting.reply?
              screen_name = status.user.screen_name
              message = "@" + screen_name + ": " + status.text
              user.unread_count.unread += 1
              user.unread_count.save!
              user.send_notification(message, "reply", status)
              p "sent reply push: #{user.screen_name}"
            end
          end
        when Twitter::DirectMessage
          next if user.uid == status.sender.id.to_s
          if user.user_setting.direct_message?
            message = "DM @" + status.sender.screen_name + ": " + status.text
            p "sent direct message push: #{user.screen_name}"
            user.unread_count.unread += 1
            user.unread_count.save!
            user.send_notification(message, "direct_message", status)
          end
        when Twitter::Streaming::Event
          next if user.uid == status.source.id.to_s

          if status.name == :favorite && user.user_setting.favorite?
            message = "@" + status.source.screen_name + "さんがお気に入りに追加しました"
            user.send_notification(message, "favorite", status)
            p "sent favorite push: #{user.screen_name}"
          end
        end
        ActiveRecord::Base.connection.close
      end
    rescue => error
      puts error.class
      puts error.message
      puts error.backtrace
      ExceptionNotifier.notify_exception(error)
      if error.class == JSON::ParserError || error.class == EOFError || error.class == Twitter::Error::ClientError || error.class == Twitter::Error::ServerError || error.class == Errno::EPIPE || error.class == Timeout::Error || error.class == Twitter::Error::ServiceUnavailable
        puts "retry start #{@user.screen_name}"
        sleep 10
        retry
      else
        @user.update_attributes!(userstream: false)
        p "stop #{@user.name}"
      end
    end
  end

end
