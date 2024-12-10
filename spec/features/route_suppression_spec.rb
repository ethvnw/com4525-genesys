# frozen_string_literal: true

require "rails_helper"

RSpec.feature("Route Suppression") do
  feature "Access to signup route" do
    specify "I cannot access the signup route" do
      visit new_user_registration_path
      expect(page.status_code).to(eq(404))
    end
  end
end
