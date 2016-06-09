class KeyCleanerService

  def self.strict_format_private(key)
    formatted = key.chars.each_slice(64).map(&:join).join("\n")
    "-----BEGIN RSA PRIVATE KEY-----\n" + formatted + "\n-----END RSA PRIVATE KEY-----\n"
  end

  def self.strict_format_public(key)
    formatted = key.chars.each_slice(64).map(&:join).join("\n")
    "-----BEGIN PUBLIC KEY-----\n" + formatted + "\n-----END PUBLIC KEY-----\n"
  end

  def self.non_strict(key)
    cleaned = key.dup
    cleaned.gsub!("-----BEGIN RSA PRIVATE KEY-----", "")
    cleaned.gsub!("-----END RSA PRIVATE KEY-----", "")
    cleaned.gsub!("-----BEGIN PUBLIC KEY-----", "")
    cleaned.gsub!("-----END PUBLIC KEY-----", "")
    cleaned.gsub!("\\n", "")
    cleaned.gsub!("\n", "")
  end
end
