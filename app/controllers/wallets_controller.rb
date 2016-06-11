class WalletsController < ApplicationController

  def new
    # if current_user && !current_user.primary_wallet.nil?
    #   redirect_to dashboard_path
    # elsif !current_user
    #   redirect_to new_user_session_path
    # end

    @wallet = Wallet.new
  end

  def create
    if key_params["wallet"]
      @private_key = KeyCleanerService.clean_user_input(params.dig("wallet", "private_key"))
    end

    @wallet = Wallet.new(
      user_id: current_user.id,
      private_key: @private_key,
    )

    if @wallet.save
      # when you make a wallet 'primary' - it removes all other 'primary' wallets
      # before_update?
      @wallet.primary! if current_user.primary_wallet.nil?
      flash[:notice] = "Wallet Created!"
      redirect_to dashboard_path
    else
      flash.now[:notice] = "Error!"
    end
  end

  private
    def key_params
      params.permit("wallet")
    end

end
