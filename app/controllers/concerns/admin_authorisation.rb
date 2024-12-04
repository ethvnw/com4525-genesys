# frozen_string_literal: true

# Admin authorisation
module AdminAuthorisation
  extend ActiveSupport::Concern

  included do
    before_action :authorize_admin
  end

  private

  def authorize_admin
    unless can?(:access, :admin_dashboard)
      flash[:alert] = "Unauthorized Access."
      redirect_to(root_path)
    end
  end
end
