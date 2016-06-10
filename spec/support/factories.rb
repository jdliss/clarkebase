FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user, :class => 'User' do
    email
    password '12345678'
    password_confirmation '12345678'
  end

  factory :wallet, :class => 'Wallet' do
    user
    status 1
  end
end
