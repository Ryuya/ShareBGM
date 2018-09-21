class MovieUrl < ApplicationRecord
  belongs_to :playlist ,dependent: :destroy
  belongs_to :user
  
  validates :url, presence: true
  validates :title, presence: false,length: {maximum: 30}
  validates :description, presence: true,length: {maximum: 350}
end
