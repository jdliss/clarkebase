class TransactionsController < ApplicationController
  before_action :wallets
  before_action :require_login

  def new
  end
end
