class ItineraryAttraction < ApplicationRecord
  belongs_to :itinerary
  belongs_to :attraction
    # This tells Rails to look for itinerary_attraction_from_id instead of itinerary_attraction_id
  # Change these lines:
  has_many :travels_from, class_name: 'Travel', foreign_key: 'itinerary_attraction_from_id', dependent: :destroy
  has_many :travels_to, class_name: 'Travel', foreign_key: 'itinerary_attraction_to_id', dependent: :destroy

  validates :day, presence: true, numericality: { greater_than: 0 }
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :starting_time, presence: true

  after_create :recommend_restaurants


  def recommend_restaurants
    # restaurant_recommendation_service = RestaurantRecommendationService.get_recommendations(latitude: attraction.latitude, longitude: attraction.longitude, 
    # dietary_preferences: itinerary.dietary_preferences)
  end

end
