# coding: utf-8
class Users::ApisController < UsersController
  before_action :only_json, except: :index
  before_action :check_application_key, except: :index
  skip_before_action :verify_authenticity_token, only: [:tweet, :direct_message_create, :upload], if: Proc.new{|app|
    request.format == :json
  }
  before_action :set_user
  before_action :set_twitter
  before_action :set_api_parameter
  before_action :clear_unread_count, only: [:home_timeline, :list_timeline, :mentions, :direct_messages]

  ## GET APIs
  def index
  end

  ## max_idはある一定以上時間が経つと遡れなくなる．多分home_timelineの上限が決まっている
  def home_timeline
    @settings[:count] = (params[:settings][:count].to_f * 1.05).to_i if params[:settings][:count].present?
    @all_response = @client.home_timeline(@settings)
    @response = @all_response[0..(params[:settings][:count].to_i - 1)]
  end

  def lists
    @response = @client.lists(@settings)
  end

  def list_timeline
    @settings[:count] = (params[:settings][:count].to_f * 1.05).to_i if params[:settings][:count].present?
    @all_response = @client.list_timeline(@settings)
    @response = @all_response[0..(params[:settings][:count].to_i - 1)]
  end

  def mentions
    @settings[:count] = (params[:settings][:count].to_f * 1.05).to_i if params[:settings][:count].present?
    @all_response = @client.mentions(@settings)
    @response = @all_response[0..(params[:settings][:count].to_i - 1)]
  end

  def direct_messages
    @settings[:count] = (params[:settings][:count].to_f * 1.05).to_i if params[:settings][:count].present?
    @all_response = @client.direct_messages(@settings)
    @response = @all_response[0..(params[:settings][:count].to_i - 1)]
  end

  def profile_banner
    @response = @client.profile_banner(@settings) rescue nil
  end

  def user
    begin
      @response = @client.user(@settings[:screen_name])
      @follower = @client.friendship?(@response.id, @user.uid.to_i)
    rescue
      render json: [], status: 500
    end
  end

  def user_timeline
    begin
      @settings[:count] = (params[:settings][:count].to_f * 1.05).to_i if params[:settings][:count].present?
      @all_response = @client.user_timeline(params[:screen_name], @settings) rescue nil
      @response = @all_response[0..(params[:settings][:count].to_i - 1)]
    rescue
      render json: [], status: 200
    end
  end

  def user_favorites
    @response = @client.favorites(params[:screen_name], @settings)
  end

  def friends
    @response = @client.friends(@settings)
  end

  def followers
    @response = @client.followers(@settings)
  end

  ## 会話を再帰的にさかのぼり
  def conversations
    @response = extend_back_conversations(@settings[:id])
  end

  def search
    @response = @client.search(params[:q], @settings)
  end

  ## POST APIs
  def tweet
    if @settings.present?
      if @settings[:media].present?
        attachment = Attachment.where(filename: @settings[:media].to_s).first
        file = File.open(attachment.filename.path)
        @client.update_with_media(params[:status], file)
      else
        @response = @client.update(params[:status].to_s, @settings)
      end
    else
      @response = @client.update(params[:status])
    end
    render action: :index
  end

  def upload
    @attachment = Attachment.new(filename: params[:media])
    @attachment.save!
  end

  def retweet
    @response = @client.retweet(@settings[:id])
    render action: :index
  end

  def favorite
    @response = @client.favorite(@settings[:id])
    render action: :index
  end

  def unfavorite
    @response = @client.unfavorite(@settings[:id])
    render action: :index
  end

  def delete
    @response = @client.status_destroy(@settings[:id])
    render action: :index
  end

  def update_settings
    if @user.user_setting.present?
      @user.user_setting.update_attributes(permitted_params)
    else
      setting = UserSetting.new(permitted_params)
      @user.user_setting = setting
      @user.save!
      count = UnreadCount.new
      count.user = @user
      count.save!
    end
    render action: :index
  end

  def direct_message_create
    @response = @client.create_direct_message(@settings[:screen_name], @settings[:text])
    render action: :index
  end

  def follow
    @response = @client.follow(@settings[:screen_name])
    render action: :index
  end

  def unfollow
    @response = @client.unfollow(@settings[:screen_name])
    render action: :index
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    def set_twitter
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV["TWITTER_CLIENT_ID"]
        config.consumer_secret = ENV["TWITTER_CLIENT_SECRET"]
        config.access_token = @user.oauth_token
        config.access_token_secret = @user.oauth_token_secret
      end
    end

    def set_api_parameter
      @settings = params[:settings].clone if params[:settings].present?
    end

    def only_json
      redirect_to root_path unless request.format == :json
    end

    def permitted_params
      params.require(:settings).permit(:notification, :reply, :favorite, :retweet, :direct_message, :device_token)
    end

    def clear_unread_count
      @user.unread_count.update_attributes(unread: 0)
    end

    def extend_back_conversations(id)
      result = []
      status = @client.status(id)
      result.push(status)
      result.concat(extend_back_conversations(status.in_reply_to_status_id)) if status.in_reply_to_status_id.present?
      return result
    end

    def check_application_key
      redirect_to root_path unless ApplicationSecrets.decrypt(request.headers["HTTP_WHALEBIRD_KEY"])
    end
end
