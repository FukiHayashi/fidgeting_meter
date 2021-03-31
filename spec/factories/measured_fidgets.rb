FactoryBot.define do
  factory :measured_fidget do
    user { nil }
    detected_at { "2021-03-31 23:56:18" }
    fidget_level { 1.5 }
    measured_time { 1.5 }
  end
end
