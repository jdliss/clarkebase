class KeyCleanerService

  def self.private_strict_format(key)
    "-----BEGIN RSA PRIVATE KEY-----\n" +
    key.chars.each_slice(60).map(&:join).join("\n") +
    "\n-----END RSA PRIVATE KEY-----"
  end

  def self.public_strict_format(key)
    "-----BEGIN PUBLIC KEY-----\n" +
    key.chars.each_slice(60).map(&:join).join("\n") +
    "\n-----END PUBLIC KEY-----"
  end

  def self.non_strict(key)
    private_key = OpenSSL::PKey::RSA.new(key)
    public_der = Base64.strict_encode64(private_key.public_key.to_der)
  end
end
