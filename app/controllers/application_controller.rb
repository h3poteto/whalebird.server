# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  include Jpmobile::ViewSelector
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Twitter::Error::Unauthorized, with: :render_unauthorized
  rescue_from Twitter::Error::BadRequest, with: :render_unauthorized
  rescue_from Twitter::Error::NotFound, with: :render_notfound
  rescue_from Twitter::Error::Forbidden, with: :render_forbidden
  rescue_from Twitter::Error::TooManyRequests, with: :render_toomany
  rescue_from Twitter::Error::ServiceUnavailable, with: :render_toomany

  def after_sign_in_path_for(resource)
    case resource
    when User
      users_apis_path
    when Admin
      sidekiq_web_path
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end


  def render_unauthorized
    current_user.user_setting.update_attributes(notification: false)
    sign_out current_user
    render nothing: true, status: 401
  end

  def render_notfound
    render json: {errors: I18n.t("users.apis.twitter.notfound")}, status: 499
  end

  def render_forbidden
    render json: {errors: I18n.t("users.apis.twitter.forbidden")}, status: 499
  end

  def render_toomany
    render json: {errors: I18n.t("users.apis.twitter.toomany")}, status: 499
  end
end
