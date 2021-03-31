FactoryBot.define do
  factory :setting do
    user { nil }
    push_notification { false }
    desktop_application_cooperation { false }
  end
end
