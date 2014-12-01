# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  include Jpmobile::ViewSelector
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    case resource
    when User
      # TODO: ログインしてたらユーザ情報でも出すか，ログアウトリンクを
      users_apis_path
    when Admin
      sidekiq_web_path
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
