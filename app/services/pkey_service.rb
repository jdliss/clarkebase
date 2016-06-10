require 'openssl'

class PKeyService

  def initialize
    @keypair = OpenSSL::PKey::RSA.generate(2048)
  end

  def private_key
    Base64.encode64(@keypair.to_der).delete("\n")
  end

  def public_key(key)
    key = KeyCleanerService.private_strict_format(key)
    Base64.encode64(OpenSSL::PKey::RSA.new(key).public_key.to_der)
  end
end
