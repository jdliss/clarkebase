class WalletsController < ApplicationController
  before_action :wallets

  def show
    @wallet = current_user.wallets.find_by(slug: params['slug'])
  end

  def new
    @wallet = Wallet.new
  end

  def create
    if params.dig("private_key")
      @private_key = KeyCleanerService.clean_user_input(params.dig("private_key"))
    end

    @wallet = Wallet.new(
      user_id:     current_user.id,
      private_key: @private_key,
      name:        "Default",
      slug:        "default"
    )

    if @wallet.save
      @wallet.primary! if current_user.primary_wallet.nil?
      flash[:notice] = "Wallet Created!"
      redirect_to dashboard_path
    else
      # need some validation
      flash.now[:notice] = "Error with Submitted Private Key!"
    end
  end
end
