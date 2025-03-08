# frozen_string_literal: true

# Contains global controller actions - all other controllers inherit from here
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Disabling caching will prevent sensitive information being stored in the
  # browser cache. If your app does not deal with sensitive information then it
  # may be worth enabling caching for performance.
  before_action :update_headers_to_disable_caching

  # Checks whether the user is on the login page
  helper_method :sign_in_page?

  # Decorate the current user
  before_action :decorate_current_user

  # Convert any flash messages to a PageAlert-compatible format
  before_action :convert_flash_messages

  def after_sign_in_path_for(resource)
    set_flash_message!(:alert, :warn_pwned) if resource.respond_to?(:pwned?) && resource.pwned?
    super
  end

  private

  rescue_from CanCan::AccessDenied do
    head :unauthorized
  end

  def update_headers_to_disable_caching
    response.headers["Cache-Control"] = 'no-cache, no-cache="set-cookie", no-store, private, proxy-revalidate'
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "-1"
  end

  def sign_in_page?
    request.path == user_session_path
  end

  def decorate_current_user
    @current_user = current_user.decorate if current_user.present?
  end

  ##
  # Converts flash messages from rails-style to bootstrap-style
  # Extracts messages from flash[:alert] or flash[:notice] and puts them in the correct format to be used by PageAlert
  def convert_flash_messages
    if flash[:alert].present?
      flash[:js_data] = { alert: { message: flash[:alert], type: "danger" } }
      flash.discard(:alert)
    elsif flash[:notice].present?
      flash[:js_data] = { alert: { message: flash[:notice], type: "success" } }
      flash.discard(:notice)
    end
  end
end
