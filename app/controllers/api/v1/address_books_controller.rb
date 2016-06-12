class Api::V1::AddressBooksController < ApiController
  def update
    if params["email"] != "" || params["email"] != nil
      @friend = User.find_by_email(params["email"])
    elsif params["key"] != "" || params["key"] != nil
      @friend = Wallet.find_by(public_key: params["key"]).user
    end

    if @friend && @friend != current_user
      current_user.friends += [@friend]
      current_user.friends.uniq!
      render json: { message: 'success' }, status: 200
    else
      render json: { message: 'error' }, status: 500
    end
  end
end
