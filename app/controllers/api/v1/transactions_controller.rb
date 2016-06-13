class Api::V1::TransactionsController < ApiController

  def create
    from_wallet = Wallet.find(params[:wallet][:id]).address
    if params.dig("address") != "" && params.dig("address") != nil
      to = params.dig("address")
    else
      to = User.find_by_email(params.dig("to")).primary_wallet.address
    end

    amount = params.dig("amount")

    transaction = Transaction.new(
      from: from_wallet,
      to: to,
      amount: amount,
    )



    if transaction.save
      render json: { message: 'success' }, status: 200
    else
      render json: { message: 'error' }, status: 500
    end
  end
end
