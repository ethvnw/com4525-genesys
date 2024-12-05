# frozen_string_literal: true

# Admin authorisation
module AdminAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :authorize_admin
  end

  private

  def authorize_admin
    unless can?(:access, :admin_dashboard)
      raise(CanCan::AccessDenied.new("Not authorized!", :access, :admin_dashboard))
    end
  end
end
