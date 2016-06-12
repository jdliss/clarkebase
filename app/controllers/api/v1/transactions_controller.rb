class Api::V1::TransactionsController < ApiController

  def create
    to = params.dig("address") if params.dig("address")
    to = User.find_by(email: params.dig("to")).primary_wallet.address if params.dig("to") != ""
    amount = params.dig("amount")

    transaction = Transaction.new(
      from: current_user.primary_wallet.address,
      to: to,
      amount: amount
    )

    if transaction.save
      render json: { message: 'success' }, status: 200
    else
      render json: { message: 'error' }, status: 500
    end
  end
end
