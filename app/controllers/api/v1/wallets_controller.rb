class Api::V1::WalletsController < ApiController
  respond_to :json

  def create
    @wallet = Wallet.create(user_id: current_user.id)
    respond_with :api, :v1, :wallets, { wallet: @wallet }
  end
end
