class Api::V1::WalletsController < ApiController

  def create
    @wallet = Wallet.new(user_id: current_user.id)
    if @wallet.save
      render json: { message: 'success' }, status: 200
    else
      render json: { message: 'error' }, status: 500
    end
  end

end
