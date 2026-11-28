class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # For use in before_action: only the drafter may manage their own queue, settings and surrogates
  def require_own_draft_participant(draft_participant)
    return if draft_participant.user_id == current_user.id

    flash[:error] = "You can only manage your own drafter."
    redirect_to draft_path(draft_participant.draft), status: :see_other
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :phone, :admin, :secret_key])
  end
end
