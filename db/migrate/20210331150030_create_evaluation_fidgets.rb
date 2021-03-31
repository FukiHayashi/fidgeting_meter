class CreateEvaluationFidgets < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluation_fidgets do |t|
      t.references :user, null: false, foreign_key: true
      t.float :comprehensive_evaluation
      t.float :frustration_level
      t.float :fidget_level_maximum
      t.datetime :evaluated_at

      t.timestamps
    end
  end
end
