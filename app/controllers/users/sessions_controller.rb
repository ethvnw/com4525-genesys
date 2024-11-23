# frozen_string_literal: true

module Users
  # Handles the usage of magic password links
  class SessionsController < Devise::SessionsController
    def send_magic_link
      # Find the user by email to see if they already exist
      user = User.find_by(email: params[:email], user_role: params[:user_role])

      if user
        flash[:notice] = "Account #{user.email} is already registered."
      else
        # If the user doesn't exist, send a magic password link
        user = User.create(email: params[:email], password: "BobSteven#*1", user_role: params[:user_role])

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
