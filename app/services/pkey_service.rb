require 'openssl'

class PKeyService

  def self.generate_private_key
    keypair = OpenSSL::PKey::RSA.generate(2048)
    keypair.to_der
  end

  def self.public_key(pkey)
    key = OpenSSL::PKey::RSA.new(pkey)
    key.public_key.to_der
  end
end
