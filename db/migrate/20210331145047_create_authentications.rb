class CreateAuthentications < ActiveRecord::Migration[6.0]
  def change
    create_table :authentications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider

      t.timestamps
    end
  end
end
