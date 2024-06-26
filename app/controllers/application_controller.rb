# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types(:danger)

  private

  def require_signin
    unless current_user
      session[:intended_url] = request.url
      redirect_to(new_session_url, alert: "Please sign in first")
    end
  end

  def require_admin
    if !current_user_admin?
      redirect_to(root_url, alert: "unauthorized access!")
    end
  end

  def current_user_admin?
    current_user && current_user.admin?
  end

  def current_user
    # @current_user ||= is important
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    current_user == user
  end

  helper_method :current_user
  helper_method :current_user?
  helper_method :current_user_admin?
end
