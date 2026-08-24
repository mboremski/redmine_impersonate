class ImpersonationController < ApplicationController
  before_action :require_login
  before_action :require_admin, only: [:create]

  require_sudo_mode :create

  def create
    if !session[:true_user_id]
      admin_user = User.current
      impersonated_user = User.active.logged.find(params[:user_id])

      # Clear any remaining data in admin's old session
      reset_session

      # Remember the original admin user in the session and set the new user for the rest of request
      session[:true_user_id] = admin_user.id
      User.current = impersonated_user

      # Start a new session for the impersonated user
      start_user_session(impersonated_user)

      # Don't require password change of target user
      session.delete(:pwd)

      # Don't drag the admin into the target user's two-factor pairing.
      # start_user_session sets this flag when the impersonated user still has
      # to activate 2FA; ApplicationController#check_twofa_activation would
      # then start the pairing (and send a code) on the target user's account.
      session.delete(:must_activate_twofa)
    end

    # Redirect to the home with the new impersonated user
    redirect_to home_url
  end

  def destroy
    true_user = User.find_by_id(session[:true_user_id])

    if true_user && true_user.active?
      self.logged_user = true_user
      session.delete(:true_user_id)
    end

    redirect_back_or_default home_path, referer: true
  end
end
