require "application_responder"

class ApiController < ApplicationController
  self.responder = ApplicationResponder
  respond_to :json
  protect_from_forgery with: :null_session
end
