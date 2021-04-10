require 'rails_helper'

RSpec.describe 'EvaluationFidgets', type: :system do
  let!(:password) { 'password' }
  let!(:user) { create(:user, password: password, password_confirmation: password) }
  let!(:setting) { create(:setting, user: user) }
  let!(:measured_fidgets) { create_list(:measured_fidget, 10, user: user, fidget_level: 1.5, measured_time: 1.0) }

  context 'クラスを生成した時' do
    before { login(user.email, password) }
    it 'fidget_time, fidget_level_maximum, fidget_calorie, comprehensive_evaluationが計算されること' do
      ef = EvaluationFidgets.new(user)
      expect(ef.evaluate_days.count).to eq 7
      expect(ef.evaluate_days.last).to eq Time.current.to_date
      expect(ef.fidget_times.last).to eq 1.0 * 10
      expect(ef.fidget_calories.last).to eq 1.0 * 10 / 3_600 * 40_000
      expect(ef.fidget_level_maximums.last).to eq 1.5
      expect(ef.comprehensive_evaluation).to eq 0
    end
  end
end
