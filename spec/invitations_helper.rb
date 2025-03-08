# frozen_string_literal: true

# Helper method to send an invitation to a new email
def submit_invitation_to_new_email(email, role)
  # Send an invitation to the new email address
  fill_in("Email address", with: email)
  select(role, from: "user_user_role")
  click_button("Send Invitation")

  # Check the user has been added to the staff table
  within("table") do
    expect(page).to(have_text(email))
    row = find("tr", text: email)
    expect(row).to(have_text(role))
  end
end
