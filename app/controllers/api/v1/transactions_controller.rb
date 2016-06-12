class Api::V1::TransactionsController < ApiController

  def create
    if params.dig("address") != "" && params.dig("address") != nil
      to = params.dig("address")
    else
      to = params.dig("to")
    end
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
