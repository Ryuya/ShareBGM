class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :user_playlists
  has_many :playlists, through: :user_playlists
  has_many :room_chat_logs
  has_many :room_members,dependent: :destroy

end
