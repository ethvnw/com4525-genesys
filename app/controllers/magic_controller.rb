# frozen_string_literal: true

# Handles the usage of magic password links
class MagicController < Devise::SessionsController
  def send_magic_link
    email = params[:email]
    role = params[:user_role]
    user = User.find_by(email: email)

    if user
      flash[:notice] = "Account #{user.email} is already registered."
    else
      # If the user doesn't exist, send a magic password link
      user = create_staff_account(email, role)
      send_magic_link_email(user)
      flash[:notice] = "Account created and email sent to #{user.email}."
    end

    redirect_to(request.referer)
  end

  private

  def create_staff_account(email, role)
    # Create a random password (#X) is to ensure it contains a capital and symbol to pass validations
    # Param 48 encodes 64 characters + 2 -> 66 passing validation
    secure_random = SecureRandom.urlsafe_base64(48) + "#X"
    User.create(email: email, password: secure_random, user_role: role)
  end

  def send_magic_link_email(user)
    # Create a token (like reset password) so the user can change their password
    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
    user.update(reset_password_token: hashed, reset_password_sent_at: Time.now.utc)
    CustomDeviseMailer.send_magic_password_instructions(user, raw).deliver_later
  end
end
