class DashboardController < ApplicationController
  before_action :wallets
  before_action :require_login

  def show
    @sent_transactions     = Wallet.all_sent_transactions(@wallets)
    @received_transactions = Wallet.all_received_transactions(@wallets)
    @recently_added_wallet = @wallets.order('created_at').last

    respond_to do |format|
      format.js { render 'show_balance' }
      format.html
    end
  end

end
