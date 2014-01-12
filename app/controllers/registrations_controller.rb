class RegistrationsController < Devise::RegistrationsController

  # Allows the user to change any information they want.
  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password
  def update
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    # Required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end
    @player = Player.find(current_player.id)

    if @player.update_attributes(account_update_params)
      set_flash_message :notice, :updated

      # Sign in while bypassing validation in case the password has changed
      sign_in @player, :bypass => true
      redirect_to after_update_path_for(@player)
    else
      render "edit"
    end
  end
end
