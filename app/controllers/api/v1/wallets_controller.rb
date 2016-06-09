class Api::V1::WalletsController < ApiController

  def create
    if params.dig("private_key")
      @private_key = Wallet.clean_input_key(params.dig("private_key"))
    end

    @wallet = Wallet.new(
      user_id: current_user.id,
      private_key: @private_key
    )

    if @wallet.save
      render json: { message: 'success' }, status: 200
    else
      render json: { message: 'error' }, status: 500
    end
  end

end
