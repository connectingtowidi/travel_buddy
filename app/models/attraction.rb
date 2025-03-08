class Attraction < ApplicationRecord
  has_many :itinerary_attractions
  has_many :itineraries, through: :itinerary_attractions

  validates :name, presence: true

  def stale?
    last_tripadvisor_update.nil? || last_tripadvisor_update < 2.weeks.ago
  end
end
