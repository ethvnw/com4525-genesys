# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src(:none)
    # Without :data, slider arrows aren't shown properly on Firefox but are on Chrome
    policy.font_src(:self, :data, "https://fonts.gstatic.com", "https://rsms.me")
    policy.style_src(:self, "https://fonts.googleapis.com", "https://rsms.me", "https://unpkg.com", :unsafe_inline)
    policy.img_src(:self, :data, "https://unpkg.com", "https://api.dicebear.com")
    policy.object_src(:none)
    policy.script_src(:self)
    policy.manifest_src(:self)

    policy.block_all_mixed_content(true)

    connect_src = [:self, "https://photon.komoot.io"]
    if Rails.env.development?
      # Allow bin/webpack-dev-server to connect via websockets in development
      connect_src += ["http://localhost:3035", "ws://localhost:3035"]
    end

    policy.connect_src(*connect_src)
  end
end
