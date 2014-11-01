class Users::ApisController < UsersController
  before_action :set_user
  before_action :set_twitter
  before_action :set_api_parameter
  skip_before_filter :verify_authenticity_token, only: [:tweet], if: Proc.new{|app|
    request.format == :json
  }

  # GET /users/apis
  # GET /users/apis.json
  def index
  end

  def home_timeline
    @response = @client.home_timeline(@settings)
  end

  def lists
    @response = @client.lists(@settings)
  end

  def list_timeline
    @response = @client.list_timeline(@settings)
  end

  def mentions
    @response = @client.mentions(@settings)
  end

  def profile_banner
    @response = @client.profile_banner(@settings)
  end

  def user
    @response = @client.user(@settings[:screen_name])
  end

  def user_timeline
    @response = @client.user_timeline(params[:screen_name], @settings)
  end

  def friends
    @response = @client.friends(@settings)
  end

  def followers
    @response = @client.followers(@settings)
  end

  def tweet
    @response = @client.update(params[:status], @settings)
    render action: :index
  end

  def retweet
    @response = @client.retweet(@settings[:id])
    render action: :index
  end

  def favorite
    @response = @client.favorite(@settings[:id])
    render action: :index
  end

  def delete
    @response = @client.status_destroy(@settings[:id])
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
      @settings = params[:settings]
    end
end
