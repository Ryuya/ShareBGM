class MovieUrl < ApplicationRecord
  belongs_to :playlist
  belongs_to :user
  
  validates :url, presence: true
  validates :title, presence: false,length: {maximum: 80}
  validates :description, presence: true,length: {maximum: 350}
  
  def get_ytid
    url.sub("https://www.youtube.com/watch?v=","").sub(/&.*/m, "")
  end
end
