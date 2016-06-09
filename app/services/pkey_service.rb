require 'openssl'

class PKeyService

  def self.generate_private_key
    keypair = OpenSSL::PKey::RSA.generate(2048)
    keypair.to_der
  end

  def self.public_key(pkey)
    pkey = Base64.encode64(pkey)
    pkey_with_headers = "-----BEGIN RSA PRIVATE KEY-----\n" + pkey + "-----END RSA PRIVATE KEY-----\n"
    key = OpenSSL::PKey::RSA.new(pkey_with_headers)
    Base64.encode64(key.public_key.to_der)
  end
end
