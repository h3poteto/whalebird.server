class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:destroy], if: Proc.new{|app|
    request.format == :json
  }
  before_action :check_application_key, only: [:new]


  private
    def check_application_key
      redirect_to root_path if params[:whalebird].to_s != ENV["WHALEBIRD_APPLICATION_KEY"]
    end
end
