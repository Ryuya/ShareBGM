class CreateRoomChatLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :room_chat_logs do |t|
      t.string :log
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
