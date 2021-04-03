class Setting < ApplicationRecord
  belongs_to :user
  validates :push_notification, inclusion: [true, false]
  validates :desktop_application_cooperation, inclusion: [true, false]
end
