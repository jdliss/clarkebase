require 'keycleaner_service'

horace = User.create(
  email:                 'horace@horace.com',
  password:              'password',
  password_confirmation: 'password'
)

# priv_key = "-----BEGIN RSA PRIVATE KEY-----\n" +
#   private_key.chars.each_slice(60).map(&:join).join("\n") +
#   "\n-----END RSA PRIVATE KEY-----\n"
#
# object = OpenSSL::PKey::RSA.new(priv_key)
# generated_der = Base64.encode64(object.to_der).delete("\n")
#
# private_key = KeyCleanerService.private_strict_format(ENV['PRIVATE_KEY'].dup)

private_key = ENV["PRIVATE_KEY"].dup
Wallet.create(user_id: horace.id, private_key: private_key)


# decoded_private_key = Base64.decode64(private_key)
# Wallet.create(user_id: horace.id, private_key: decoded_private_key)
