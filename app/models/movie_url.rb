class MovieUrl < ApplicationRecord
  belongs_to :playlist
  belongs_to :user
  
  validates :url, presence: true
  validates :title, presence: true,length: {maximum: 20}
  validates :description, presence: true,length: {maximum: 120}
end
