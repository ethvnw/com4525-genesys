# frozen_string_literal: true

##
# Searches for and selects a location from the dropdown
#
# @param [String] location - the location to search for
def select_location(location)
  # Stub Photon API to ensure no external call is made
  stub_photon_api(location)

  # Disable VCR for the autocomplete interaction, so that the webmock-stubbed request is used instead
  VCR.turn_off!
  find(".aa-DetachedSearchButton").click
  find(".aa-Input").set(location)
  sleep_for_js
  find_all(".aa-Item").first.click
  VCR.turn_on!
end
