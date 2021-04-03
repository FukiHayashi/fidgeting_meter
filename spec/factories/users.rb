FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user-#{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt('password', 'salt') }
    salt { 'salt' }
  end
end
