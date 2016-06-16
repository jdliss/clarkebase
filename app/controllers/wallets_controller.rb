class WalletsController < ApplicationController
  before_action :wallets
  before_action :require_login

  def show
    @wallet                = current_user.wallets.find_by(slug: params['slug'])
    @sent_transactions     = @wallet.sent_transactions
    @received_transactions = @wallet.received_transactions
  end

  def new
    redirect_to dashboard_path and return if current_user.wallets.exists?
    @wallet = Wallet.new
  end

  def create
    if params.dig("private_key")
      private_der = KeyCleanerService.clean_user_input(params.dig("private_key"))
      der_with_headers = KeyCleanerService.private_strict_format(private_der)
      keypair = OpenSSL::PKey::RSA.new(der_with_headers)
      @private_key = PKeyService.new(keypair).private_key
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
