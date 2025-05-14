# frozen_string_literal: true

require "rails_helper"

RSpec.feature("User Avatar") do
  let(:user) { create(:user) }

  before do
    login_as(user)
    visit edit_user_registration_path
  end

  feature "Updating avatar" do
    scenario "Uploading a valid image file (PNG, JPG, JPEG)" do
      attach_file("user[avatar]", Rails.root.join("spec", "support", "files", "mock_avatar.png"))
      click_button "Save"
      expect(page).to(have_content("Avatar updated successfully."))
      expect(user.avatar.filename).to(eq("mock_avatar.png"))
    end

    scenario "Not uploading any image" do
      # No image file attached
      click_button "Save"
      expect(page).to(have_content("No avatar photo uploaded."))
    end

    scenario "Uploading an invalid file type" do
      attach_file("user[avatar]", Rails.root.join("spec", "support", "files", "test.txt"))
      click_button "Save"
      expect(page).to(have_content("Avatar has an invalid content type (authorized content types are PNG, JPG, WEBP)"))
    end

    scenario "Uploading a file that exceeds the 5 MB size limit" do
      large_file = Rails.root.join("spec", "support", "files", "large_avatar.jpg")

      # Creating an image file larger than 5 MB
      File.open(large_file, "wb") do |f|
        f.write("0" * 6.megabytes)
      end

      attach_file("user[avatar]", large_file)
      click_button "Save"
      expect(page).to(have_content("Avatar file size must be less than 5 MB (current size is 6 MB)"))
    end
  end

  feature "Removing avatar" do
    scenario "When the user has an avatar" do
      # Make sure mock avatar image is attached
      expect(user.avatar.filename).to(eq("mock_avatar.png"))

      click_button "Reset Avatar Photo"
      expect(user.reload.avatar.filename).to(be_nil)
      expect(page).to(have_content("Avatar successfully removed."))
    end

    scenario "When the user does not have an avatar" do
      no_avatar_user = create(:user, :no_avatar, email: "no_avatar@example.com", username: "no_avatar")
      login_as(no_avatar_user)
      visit edit_user_registration_path

      expect(page).not_to(have_button("Remove Avatar Photo"))
    end
  end
end
