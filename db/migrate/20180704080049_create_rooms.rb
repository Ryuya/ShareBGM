class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.boolean :closed_at
      t.references :playlist, foreign_key: true
      t.integer :admin_user_id
      t.string :description

      t.timestamps
    end
  end
end
