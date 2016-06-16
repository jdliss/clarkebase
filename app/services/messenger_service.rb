class MessengerService
  def self.send_message(message, number)
    new.send_message(message, number)
  end

  def initialize
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new(account_sid, auth_token)
  end

  def send_message(message, number)
    @client.account.messages.create(
      from:  ENV["TWILIO_NUMBER"],
      to:    number,
      body:  message
    )
  end
end
