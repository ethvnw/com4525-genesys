# frozen_string_literal: true

# Reporter authorisation
module ReporterAuthorisation
  extend ActiveSupport::Concern

  included do
    before_action :authorize_reporter
  end

  private

  def authorize_reporter
    unless can?(:access, :reporter_dashboard)
      flash[:alert] = "Unauthorized Access."
      redirect_to(root_path)
    end
  end
end
