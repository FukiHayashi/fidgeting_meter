FactoryBot.define do
  factory :evaluation_fidget do
    user { nil }
    comprehensive_evaluation { 1.5 }
    frustration_level { 1.5 }
    fidget_level_maximum { 1.5 }
  end
end
