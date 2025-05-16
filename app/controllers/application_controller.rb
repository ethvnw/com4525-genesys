# frozen_string_literal: true

# Contains global controller actions - all other controllers inherit from here
class ApplicationController < ActionController::Base
  include Pagy::Backend

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

  # Permit parameters such as username and email
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :check_for_notifications

  # Permit username and email when signing up or updating details
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :avatar])
  end

  def after_sign_in_path_for(resource)
    set_flash_message!(:alert, :warn_pwned) if resource.respond_to?(:pwned?) && resource.pwned?
    super
  end

  def current_user
    @current_user ||= super && User.includes(avatar_attachment: :blob).find(current_user.id)
  end

  private

  rescue_from CanCan::AccessDenied do
    @status_code = 401
    render("errors/401", status: :unauthorized, layout: "error")
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    @status_code = 401
    render("errors/401", status: :unauthorized, layout: "error")
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
  # Extracts messages from flash[:alert] or flash[:notice] and puts them in the correct format to be used by toasts
  def convert_flash_messages
    flash[:notifications] ||= []

    if flash[:alert].present?
      flash[:notifications] << { message: flash[:alert], notification_type: "danger" }
      flash[:alert] = nil
    elsif flash[:notice].present?
      flash[:notifications] << { message: flash[:notice], notification_type: "success" }
      flash[:notice] = nil
    end
  end

  def authorize_members_access!
    authorize!(:access, :landing)
    authorize!(:access, :faq)
    authorize!(:access, :subscription)
  rescue CanCan::AccessDenied
    redirect_to(
      home_path,
      flash: { notice: flash[:notice], alert: flash[:alert], notifications: flash[:notifications] },
    )
  end

  def restrict_admin_and_reporter_access!
    unless current_user.member?
      redirect_to(root_path, alert: "Unable to access members-only page as a staff user.")
    end
  end

  # Set layout based on user membership status
  def apply_user_layout!
    if current_user&.member?
      self.class.layout("user")
    else
      self.class.layout("application")
    end
  end

  def check_for_notifications
    return unless current_user

    pending_trip_memberships = current_user.trip_memberships.where(is_invite_accepted: false)
    @inbox_count = pending_trip_memberships.count
  end
end
