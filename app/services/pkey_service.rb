require 'openssl'

class PKeyService
  attr_accessor :private_key, :public_key

  def initialize
    @keypair = OpenSSL::PKey::RSA.generate(2048)
  end

  def private_key
    Base64.encode64(@keypair.to_der).delete("\n")
  end

  def public_key
    Base64.encode64(@keypair.public_key.to_der).delete("\n")
  end
end
