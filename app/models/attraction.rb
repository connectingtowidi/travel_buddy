class Attraction < ApplicationRecord
  has_many :itinerary_attractions, dependent: :destroy
  has_many :itineraries, through: :itinerary_attractions

  validates :name, presence: true
end
