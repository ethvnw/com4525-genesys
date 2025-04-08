# frozen_string_literal: true

##
# Searches for and selects a location from the dropdown
#
# @param [String] location - the location to search for
def select_location(location)
  # Stub Photon API to ensure no external call is made
  stub_photon_api(location)

  find(".aa-DetachedSearchButton").click
  find(".aa-Input").set(location)
  sleep_for_js
  find_all(".aa-Item").first.click
end
