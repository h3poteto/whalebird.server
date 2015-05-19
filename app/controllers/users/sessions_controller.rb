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

  def destroy
    current_user.user_setting.stop_userstream if current_user.user_setting.present?
    super
  end

  private
    def check_application_key
      redirect_to root_path unless ApplicationSecrets.decrypt(request.headers["HTTP_WHALEBIRD_KEY"])
    end
end
