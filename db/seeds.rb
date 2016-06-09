require 'keycleaner_service'

horace = User.create(
  email:                 'horace@horace.com',
  password:              'password',
  password_confirmation: 'password'
)

private_key = KeyCleanerService.private_strict_format(ENV['PRIVATE_KEY'].dup)
Wallet.create(user_id: horace.id, private_key: private_key)

# decoded_private_key = Base64.decode64(private_key)
# Wallet.create(user_id: horace.id, private_key: decoded_private_key)
