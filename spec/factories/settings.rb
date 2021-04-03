FactoryBot.define do
  factory :setting do
    user
    push_notification { false }
    desktop_application_cooperation { false }
  end
end
