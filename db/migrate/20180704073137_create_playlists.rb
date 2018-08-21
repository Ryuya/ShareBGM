class CreatePlaylists < ActiveRecord::Migration[5.2]
  def change
    create_table :playlists do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
