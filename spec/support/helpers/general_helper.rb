# frozen_string_literal: true

##
# Detects whether a test is running with the `js: true` flag
def js_true?
  RSpec.current_example.metadata[:js]
end
