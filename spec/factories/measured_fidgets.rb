FactoryBot.define do
  factory :measured_fidget do
    detected_at { Time.current }
    fidget_level { 1.5 }
    measured_time { 1.5 }
  end
end
