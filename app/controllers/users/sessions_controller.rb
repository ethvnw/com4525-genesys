# frozen_string_literal: true

module Users
  # Handles the usage of magic password links
  class SessionsController < Devise::SessionsController
    def send_magic_link
      user = User.find_by(email: params[:email])
      # Create a random password (#X) is to ensure it contains a capital and symbol to pass validations
      # Param 48 encodes 64 characters + 2 -> 66 passing validation
      secure_random = SecureRandom.urlsafe_base64(48) + "#X"

      if user
        flash[:notice] = "Account #{user.email} is already registered."
      else
        # If the user doesn't exist, send a magic password link
        user = User.create(email: params[:email], password: secure_random, user_role: params[:user_role])

        # Create a token (like reset password) so the user can change their password
        raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
        user.update(reset_password_token: hashed, reset_password_sent_at: Time.now.utc)
        CustomDeviseMailer.send_magic_password_instructions(user, raw).deliver_later

        flash[:notice] = "Account created and email sent to #{user.email}."
      end

      # Redirect to the same page
      redirect_to(request.referer)
    end
  end
end
