# frozen_string_literal: true

##
# Class to suppress sign up route, as signup is not a requirement for now.
# Will be disabled next semester, when signup is a requirement.
class RouteSuppressorMiddleware
  SUPPRESS_ROUTES = [
    "GET /users/sign_up",
    "POST /users",
  ]

  def initialize(app)
    @app = app
  end

  def call(env)
    if SUPPRESS_ROUTES.include?("#{env["REQUEST_METHOD"]} #{env["PATH_INFO"]}")
      content = "Not Found"
      return [404, { "Content-Type" => "text/html", "Content-Length" => content.size.to_s }, [content]]
    end

    @app.call(env)
  end
end
