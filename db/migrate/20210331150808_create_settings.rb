class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :push_notification, null: false, default:false
      t.boolean :desktop_application_cooperation, null: false, default: false

      t.timestamps
    end
  end
end
