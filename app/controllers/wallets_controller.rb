class WalletsController < ApplicationController
  before_action :wallets

  def show
    @wallet = Wallet.find(params["id"])
  end

  def new
    @wallet = Wallet.new
  end

  def create
    if key_params["wallet"]
      @private_key = KeyCleanerService.clean_user_input(key_params.dig("wallet", "private_key"))
    end

    @wallet = Wallet.new(
      user_id:     current_user.id,
      private_key: @private_key,
    )

    if @wallet.save
      @wallet.primary! if current_user.primary_wallet.nil?
      flash[:notice] = "Wallet Created!"
      redirect_to dashboard_path
    else
      flash.now[:notice] = "Error with Submitted Private Key!"
    end
  end

  private
    def key_params
      params.permit("wallet")
    end
end
