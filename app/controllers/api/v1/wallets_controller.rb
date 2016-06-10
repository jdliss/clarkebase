class Api::V1::WalletsController < ApiController

  def create
    if params.dig("private_key")
      @private_key = KeyCleanerService.clean_user_input(params.dig("private_key"))
    end

    @wallet = Wallet.new(
      user_id: current_user.id,
      private_key: @private_key,
    )

    if @wallet.save
      # this would create each wallet as primary
      # need first wallet to always be primary
      # all others will default to 'basic'
      # when you make a wallet 'primary' - it removes all other 'primary' wallets
      if current_user.primary_wallet.nil? ? @wallet.primary!

      render json: { message: 'success' }, status: 200
    else
      render json: { message: 'error' }, status: 500
    end
  end

end
