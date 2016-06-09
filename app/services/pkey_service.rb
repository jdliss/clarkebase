require 'openssl'

class PKeyService

  def initialize
    @keypair = OpenSSL::PKey::RSA.generate(2048)
  end

  def private_key
    @keypair.to_pem
  end

  def public_key
    @keypair.public_key.to_pem
  end
end
