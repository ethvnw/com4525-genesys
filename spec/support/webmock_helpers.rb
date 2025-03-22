# frozen_string_literal: true

module WebMockHelpers
  def stub_photon_api
    stub_request(:get, %r{https://photon.komoot.io/api/\?q=.*&limit=5})
      .to_return(
        status: 200,
        body: {
          "features": [
            {
              "geometry": {
                "coordinates": [-1.48336878058616, 53.3815042],
              },
              "properties": {
                "name": "University of Sheffield",
                "city": "Sheffield",
                "country": "United Kingdom",
              },
            },
          ],
        }.to_json,
        headers: { "Content-Type": "application/json" },
      )
  end
end
