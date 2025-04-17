class AddCountryCodeIsoToFeaturedLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :featured_locations, :country_code_iso, :string
  end
end
