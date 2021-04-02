FactoryBot.define do
  factory :api_key do
    user { nil }
    access_token { "MyString" }
    expires_at { "2021-04-01 00:10:31" }
  end
end
