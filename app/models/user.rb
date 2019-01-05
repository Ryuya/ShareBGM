class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
         
  has_many :user_playlists
  has_many :playlists, through: :user_playlists
  has_many :room_chat_logs
  has_many :room_members,dependent: :destroy
  has_many :rooms,foreign_key: :admin_user_id
  
  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
 
    unless user
      user = User.create(
        uid:      auth.uid,
        provider: auth.provider,
        email:    User.dummy_email(auth),
        password: Devise.friendly_token[0, 20],
        image: auth.info.image,
        name: auth.info.name,
        nickname: auth.info.nickname,
        location: auth.info.location
      )
    end
 
    user
  end
 
  private
 
  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
