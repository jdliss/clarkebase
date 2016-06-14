class AddressBooksController < ApplicationController
  before_action :wallets
  before_action :require_login

  def show
    respond_to do |format|
      format.js { render 'add_friend'}
      format.html
    end
  end
end
