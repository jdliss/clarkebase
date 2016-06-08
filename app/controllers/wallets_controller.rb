class WalletsController < ApplicationController
  def new
    redirect_to dashboard_path if !current_user.wallet.nil?
  end
end
