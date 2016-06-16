class Api::V1::PhonesController < ApiController
  def update
    respond_with current_user.update(phone: params[:phone_number])
  end
end
