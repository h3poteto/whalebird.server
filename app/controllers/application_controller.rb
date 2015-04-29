# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  include Jpmobile::ViewSelector
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Twitter::Error::Unauthorized, with: :render_unauthorized
  rescue_from Twitter::Error::NotFound, with: :render_notfound
  rescue_from Twitter::Error::Forbidden, with: :render_forbidden

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


  def render_unauthorized
    render nothing: true, status: 401
  end

  def render_notfound
    render json: {errors: I18n.t("users.apis.twitter.notfound")}, status: 500
  end

  def render_forbidden
    render json: {errors: I18n.t("users.apis.twitter.forbidden")}, status: 500
  end
end
