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
        user = User.create(email: params[:email], password: "BobSteven#*1", user_role: params[:user_role]) # SecureRandom.hex(10)
        user.send_reset_password_instructions
        flash[:notice] = "Account created and email sent to #{user.email}."
      end

      redirect_to(new_user_session_path)
    end
  end
end
