# frozen_string_literal: true

# Error controller
# Based upon tutorial from Ayush Newatia, 2022
# [https://dev.to/ayushn21/custom-error-pages-in-rails-4i43]
class ErrorsController < ApplicationController
  layout "error"

  def show
    @exception = request.env["action_dispatch.exception"]
    @status_code = @exception.try(:status_code) ||
      ActionDispatch::ExceptionWrapper.new(
        request.env, @exception
      ).status_code

    render(view_for_code(@status_code), status: @status_code)
  end

  private

  def view_for_code(code)
    supported_error_codes.fetch(code, "500")
  end

  def supported_error_codes
    {
      401 => "401",
      404 => "404",
      422 => "422",
      500 => "500",
    }
  end
end
