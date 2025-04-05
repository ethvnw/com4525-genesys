# frozen_string_literal: true

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
