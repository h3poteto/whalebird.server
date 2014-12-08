class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:destroy], if: Proc.new{|app|
    request.format == :json
  }
  before_action :check_application_key, only: [:new]

  def new
    request.format = :html
    params = { controller: "users/sessions", action: "new" }
    super
  end


  private
    def check_application_key
      if Rails.env.production?
        redirect_to root_path if params[:whalebird].to_s != ENV["WHALEBIRD_APPLICATION_KEY"]
      end
    end
end
