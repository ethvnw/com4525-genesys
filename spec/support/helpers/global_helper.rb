# frozen_string_literal: true

##
# Waits for a flash message to appear before continuing
# Prevents flakiness caused by (e.g.) checking for the existence of a trip before it has saved
#
# @param message [String] the message that should appear before continuing
def await_message(message)
  within("#toast-list") do
    expect(page).to(have_content(message, wait: 10))
  end
end

##
# Detects whether a test is running with the `js: true` flag
def js_true?
  RSpec.current_example.metadata[:js]
end

##
# Sets the system and JavaScript time to a specific date or time
# Hop in the Delorean!
#
# @param date_or_time [Time, Date] The time or date to set across the test environment
def time_travel_everywhere(date_or_time)
  travel_to(date_or_time)

  if js_true?
    ENV["TEST_TIMESTAMP"] = date_or_time.to_s
  end
end

##
# Resets the system and JavaScript time back to the present
# Hop in the Delorean!
def time_travel_back
  travel_back

  ENV.delete("TEST_TIMESTAMP")
end

##
# Opens a file & creates a new Rack::Test::UploadedFile within a block, to avoid creating dangling file handlers.
# Avoids "Errno::EMFILE: Too many open files @ rb_sysopen"
def safely_create_file(filename, mime_type)
  File.open(Rails.root.join("spec", "support", "files", filename)) do |file|
    Rack::Test::UploadedFile.new(file, mime_type)
  end
end
