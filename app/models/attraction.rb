class Attraction < ApplicationRecord
  has_many :itinerary_attractions
  has_many :itineraries, through: :itinerary_attractions
  has_one_attached :photo

  validates :name, presence: true
end
