# frozen_string_literal: true

##
# Fills in the registration form with an email
# @param email [String] the email to register with
def register_with_email(email: "test@example.com")
  fill_in("registration_email", with: email)
  click_on("Notify Me")

  if js_true?
    # Visit root path to trick capybara into waiting for database to update
    visit(root_path)
  end
end

##
# Shares a method (from the root path)
#
# @param feature [AppFeature] the feature to share
# @param method [String] the method to share with
def share_feature(feature, method)
  click_button(id: "share_#{feature.id}")
  click_link(method)
  find(".offcanvas-backdrop").click
end
