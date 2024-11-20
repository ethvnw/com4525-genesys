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
  # Temporarily added for creating user roles during sign up
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    set_flash_message!(:alert, :warn_pwned) if resource.respond_to?(:pwned?) && resource.pwned?
    super

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_role])
  end

  private

  def update_headers_to_disable_caching
    response.headers["Cache-Control"] = 'no-cache, no-cache="set-cookie", no-store, private, proxy-revalidate'
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "-1"
  end
end
