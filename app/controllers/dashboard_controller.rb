class DashboardController < ApplicationController
  before_action :wallets

  def show
    @transactions = current_user.primary_wallet.transactions
  end
end
