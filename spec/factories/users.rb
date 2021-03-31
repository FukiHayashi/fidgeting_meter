FactoryBot.define do
  factory :user do
    name { "MyString" }
    email { "MyString" }
    crypted_password { "MyString" }
    salt { "MyString" }
  end
end
