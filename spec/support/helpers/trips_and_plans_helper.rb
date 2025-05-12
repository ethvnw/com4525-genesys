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

def select_combined_date_range(start_date, end_date)
  find("#datetimepicker-input").click
  find("div[data-value='#{start_date}']").click
  find("div[data-value='#{end_date}']").click
end

def select_seperated_date_range(start_date, end_date)
  find("#start-datetimepicker-input").click
  find("div[data-value='#{start_date}']").click
  find("#end-datetimepicker-input").click
  find("div[data-value='#{end_date}']").click
end

def clear_start_date
  find("#start-datetimepicker-input").click
  find("div[data-action='clear']").click
end

def expect_to_have_trip_as_list_item(trip, readable_date_range)
  within("a[href='/trips/#{trip.id}']") do |trip_card|
    expect(trip_card).to(have_content(trip.title))
    expect(trip_card).to(have_content(readable_date_range))
    expect(trip_card).to(have_selector("img[src='#{url_for(trip.decorate.webp_image)}']"))
  end
end

def expect_to_have_trip_on_map(trip)
  within(".leaflet-div-icon a[href='/trips/#{trip.id}']") do |trip_marker|
    expect(trip_marker).to(have_content(trip.title))
  end

  trip_information = JSON.parse(page.find("#map-variables", visible: false)["data-marker-coords"])

  expect(trip_information).to(include({
    "id" => trip.id,
    "title" => trip.title,
    "coords" => [trip.location_latitude, trip.location_longitude],
    "href" => "/trips/#{trip.id}",
  }))
end
