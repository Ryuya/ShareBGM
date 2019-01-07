class Playlist < ApplicationRecord
    belongs_to :user
    has_many :user_playlists,dependent: :destroy
    has_many :movie_urls,dependent: :destroy
    has_many :users, through: :user_playlists
    # has_many :rooms
    has_one :room
    
    accepts_nested_attributes_for :movie_urls, reject_if: :all_blank , allow_destroy: true 
    
    validates :name, presence: true,length: {maximum: 35}
    validates :description,length: {maximum: 350}
end
