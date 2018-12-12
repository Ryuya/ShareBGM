class Room < ApplicationRecord
  belongs_to :playlist 
  has_many :room_chat_logs,dependent: :destroy
  
  validates :name, presence: true,length: {maximum: 35}
  validates :description,presence: true,length: {maximum: 350}
  validates :playlist_id,presence: true

end