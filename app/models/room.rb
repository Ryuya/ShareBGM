class Room < ApplicationRecord
  belongs_to :playlist 
  has_many :room_chat_logs
end