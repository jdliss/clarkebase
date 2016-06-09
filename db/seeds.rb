
horace = User.create(
  email:                 'horace@horace.com',
  password:              'password',
  password_confirmation: 'password'
)

private_key = ENV['PRIVATE_KEY']

decoded_private_key = private_key.dup

Wallet.create(user_id: horace.id, private_key: decoded_private_key)
