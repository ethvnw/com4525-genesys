# frozen_string_literal: true

DOWNLOAD_PATH = Rails.root.join("tmp", "downloads").freeze

Capybara.register_driver(:headless_chrome) do |app|
  chrome_options = Selenium::WebDriver::Chrome::Options.new
  chrome_options.add_argument("--headless=new") unless ENV["SHOW_CHROME"]
  chrome_options.add_argument("--no-sandbox")
  chrome_options.add_argument("--disable-gpu")
  chrome_options.add_argument("--disable-dev-shm-usage")
  chrome_options.add_argument("--disable-infobars")
  chrome_options.add_argument("--disable-extensions")
  chrome_options.add_argument("--disable-popup-blocking")
  chrome_options.add_argument("--window-size=1920,1080")

  chrome_options.add_preference(
    :download,
    prompt_for_download: false,
    default_directory: DOWNLOAD_PATH,
  )
  chrome_options.add_preference(:browser, set_download_behavior: { behavior: "allow" })

  if ENV["SELENIUM_HOST"]
    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: "http://#{ENV["SELENIUM_HOST"]}:#{ENV["SELENIUM_PORT"]}/wd/hub",
      capabilities: chrome_options,
    ) do |driver|
      bridge = driver.browser.send(:bridge)

      path = "/session/:session_id/chromium/send_command"
      path[":session_id"] = bridge.session_id

      bridge.http.call(
        :post,
        path,
        cmd: "Page.setDownloadBehavior",
        params: {
          behavior: "allow",
          downloadPath: DOWNLOAD_PATH,
        },
      )
    end
  else
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options) do |driver|
      bridge = driver.browser.send(:bridge)

      path = "/session/:session_id/chromium/send_command"
      path[":session_id"] = bridge.session_id

      bridge.http.call(
        :post,
        path,
        cmd: "Page.setDownloadBehavior",
        params: {
          behavior: "allow",
          downloadPath: DOWNLOAD_PATH,
        },
      )
    end
  end
end
Capybara.javascript_driver = :headless_chrome

if ENV["SELENIUM_HOST"]
  RSpec.configure do |config|
    config.before(:each, js: true) do
      if ENV["SELENIUM_HOST"]
        Capybara.app_host = "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}"
      end
    end

    config.after(:each, js: true) do
      Capybara.reset_sessions!
      Capybara.use_default_driver
      Capybara.app_host = nil
    end
  end

  Capybara.configure do |config|
    config.server_host = if RUBY_PLATFORM.match(/linux/)
      %x(/sbin/ip route|awk '/scope/ { print $9 }').chomp
    else
      "127.0.0.1"
    end
  end
end
