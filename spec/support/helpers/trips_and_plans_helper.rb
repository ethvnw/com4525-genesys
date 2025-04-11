# frozen_string_literal: true

def stub_photon_api(country = "England")
  stub_request(:get, /photon\.komoot\.io/)
    .to_return(
      status: 200,
      body: {
        "features": [
          {
            "geometry": {
              "coordinates": [-1.48336878058616, 53.3815042],
            },
            "properties": {
              "name": "Mock Place Name",
              "city": "Mock City",
              "country": country,
            },
          },
        ],
      }.to_json,
      headers: { "Content-Type": "application/json" },
    )
end

##
# Searches for and selects a location from the dropdown
#
# @param location [String] the location to search for
def select_location(location)
  # Stub Photon API to ensure no external call is made
  stub_photon_api(location)

  # Disable VCR for the autocomplete interaction, so that the webmock-stubbed request is used instead
  VCR.turn_off!
  find(".aa-DetachedSearchButton").click
  find(".aa-Input").set(location)
  expect(page).to(have_selector(".aa-Item"))
  find_all(".aa-Item").first.click
  VCR.turn_on!
end

def select_date_range(start_date, end_date)
  find("#datetimepicker-input").click
  find("div[data-value='#{start_date}']").click
  find("div[data-value='#{end_date}']").click
end
