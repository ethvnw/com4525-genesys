class RenameCountryCodeIsoInLandingPageVisits < ActiveRecord::Migration[7.0]
  def change
    rename_column :landing_page_visits, :country_code_iso, :country_code
  end
end