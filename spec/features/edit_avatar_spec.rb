# frozen_string_literal: true

require "rails_helper"

RSpec.feature("User Avatar") do
  let(:user) { create(:user) }

  before do
    login_as(user)
    visit edit_user_registration_path
  end

  feature "Updating avatar" do
    scenario "With a valid image file (PNG, JPG, JPEG)" do
      attach_file("user[avatar]", Rails.root.join("spec", "support", "files", "mock_avatar.png"))
      click_button "Save"
      expect(page).to(have_content("Avatar updated successfully."))
      expect(user.avatar.filename).to(eq("mock_avatar.png"))
    end

    scenario "When no avatar is uploaded" do
      # No image file attached
      click_button "Save"
      expect(page).to(have_content("No avatar photo uploaded."))
    end

    scenario "With an invalid file type" do
      attach_file("user[avatar]", Rails.root.join("spec", "support", "files", "test.txt"))
      click_button "Save"
      expect(page).to(have_content("Avatar has an invalid content type (authorized content types are PNG, JPG)"))
    end

    scenario "With a file that exceeds the 5 MB size limit" do
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

      click_button "Remove Avatar Photo"
      expect(user.reload.avatar.filename).to(be_nil)
      expect(page).to(have_content("Avatar successfully removed."))
    end

    scenario "When the user does not have an avatar" do
      expect(page).to(have_button("Remove Avatar Photo"))
      # Remove existing mock avatar image (which is already attached)
      click_button "Remove Avatar Photo"
      expect(page).not_to(have_button("Remove Avatar Photo"))
    end
  end
end
