class WalletsController < ApplicationController
  def new
    if current_user && !current_user.primary_wallet.nil?
      redirect_to dashboard_path
    elsif !current_user
      redirect_to new_user_session_path
    end
  end
end
