# frozen_string_literal: true

##
# Fills in the registration form with an email
# @param [String (frozen)] email the email to register with
def register_with_email(email: "test@example.com")
  fill_in("registration_email", with: email)
  click_on("Notify Me")
end

##
# Shares a method (from the root path)
#
# @param [AppFeature] feature the feature to share
# @param [String] method the method to share with
def share_feature(feature, method)
  click_button(id: "share_#{feature.id}")
  click_link(method)
  find(".offcanvas-backdrop").click
end
