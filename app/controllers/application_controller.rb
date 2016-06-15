class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  def after_sign_in_path_for(resource)
    new_wallet_path
  end

  def require_login
    redirect_to new_user_session_path and return unless current_user
  end

  def wallets
    @wallets = current_user.wallets if current_user
  end
end
