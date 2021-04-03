class CreateMeasuredFidgets < ActiveRecord::Migration[6.0]
  def change
    create_table :measured_fidgets do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :detected_at
      t.float :fidget_level
      t.float :measured_time

      t.timestamps
    end
  end
end
