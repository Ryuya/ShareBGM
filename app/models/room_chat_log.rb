class RoomChatLog < ApplicationRecord
  belongs_to :user
  belongs_to :room
  after_create_commit { RoomChatLogBroadcastJob.perform_later self }
end
