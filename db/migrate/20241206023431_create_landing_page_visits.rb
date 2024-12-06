class CreateLandingPageVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :landing_page_visits do |t|
      t.string :country_code_iso

      t.timestamps
    end
  end
end
