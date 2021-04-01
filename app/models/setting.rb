class Setting < ApplicationRecord
  belongs_to :user
  validates :push_notification, presence: true
  validates :desktop_application_cooperation, presence: true
end
