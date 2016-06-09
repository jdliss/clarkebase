
horace = User.create(
  email:                 'horace@horace.com',
  password:              'password',
  password_confirmation: 'password'
)

private_key = ENV['PEM_PRIVATE_KEY']
Wallet.create(user_id: horace.id, private_key: private_key)

# decoded_private_key = Base64.decode64(private_key)
# Wallet.create(user_id: horace.id, private_key: decoded_private_key)
