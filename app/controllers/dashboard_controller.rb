class DashboardController < ApplicationController

  def show
    @wallets = current_user.wallets
  end
end
