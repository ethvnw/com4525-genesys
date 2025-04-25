# frozen_string_literal: true

# Middleware to block calls to the tile API - using VCR for so many requests is seemingly impossible:
# - Loads of requests are made at the same time, which leads to nesting of cassettes
# - Requests are made at the same time as VCR is disabled to mock the location selector, leading to an error
# Much easier to just block calls to the tile API, given it isn't needed for testing
class TestBlockMapTiles
  def initialize(app)
    @app = app
  end

  def call(env)
    if "#{env["REQUEST_METHOD"]} #{env["PATH_INFO"]}".include?("GET /api/map/tile")
      content = "Not Found"
      return [404, { "Content-Type" => "text/html", "Content-Length" => content.size.to_s }, [content]]
    end

    # Pass request along middleware stack
    @app.call(env)
  end
end
