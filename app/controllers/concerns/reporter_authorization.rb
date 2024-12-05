# frozen_string_literal: true

# Reporter authorisation
module ReporterAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :authorize_reporter
  end

  private

  def authorize_reporter
    unless can?(:access, :reporter_dashboard)
      raise(CanCan::AccessDenied.new("Not authorized!", :access, :reporter_dashboard))
    end
  end
end
