# frozen_string_literal: true

def expect_to_share_to(url_start, content)
  # Stub redirect_to to avoid actually redirecting, thus eliminating external dependency
  expect_any_instance_of(Api::FeaturesController).to(receive(:redirect_to)) do |controller, redirect_options|
    decoded_link = CGI.unescape(redirect_options)
    expect(decoded_link).to(start_with(url_start))
    content.each do |content_part|
      expect(decoded_link).to(include(content_part))
      expect(decoded_link).to(include(content_part))
    end

    # Render a mock response to prevent ActionController::MissingExactTemplate error
    controller.render(plain: "Mock Response")
  end
end
