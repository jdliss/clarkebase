require 'openssl'

class PKeyService

  def self.generate_private_key
    keypair = OpenSSL::PKey::RSA.generate(2048)
    keypair.to_der
  end
end
