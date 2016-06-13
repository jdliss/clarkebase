class AddressBooksController < ApplicationController
  before_action :wallets

  def show
    respond_to do |format|
      format.js { render 'add_friend'}
      format.html
    end
  end
end
