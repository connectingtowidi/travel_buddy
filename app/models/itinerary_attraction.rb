class ItineraryAttraction < ApplicationRecord
  belongs_to :itinerary
  belongs_to :attraction
    # This tells Rails to look for itinerary_attraction_from_id instead of itinerary_attraction_id
  # Change these lines:
  has_many :travels_from, class_name: 'Travel', foreign_key: 'itinerary_attraction_from_id', dependent: :destroy
  has_many :travels_to, class_name: 'Travel', foreign_key: 'itinerary_attraction_to_id', dependent: :destroy
  has_many :restaurant_recommendations, dependent: :destroy
  validates :day, presence: true, numericality: { greater_than: 0 }
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :starting_time, presence: true

  after_create :recommend_restaurants

  private

  def recommend_restaurants
    return unless attraction && itinerary  # Ensure these exist
  
    recommendations = RestaurantRecommendationService.get_recommendations(
      latitude: attraction.latitude,
      longitude: attraction.longitude,
      dietary_preferences: itinerary.dietary_preferences
    )
  
    unless recommendations.is_a?(Array)
      Rails.logger.warn("Unexpected recommendations format: #{recommendations.inspect}")
      return
    end
  
    recommendations.each do |restaurant|
      restaurant_recommendations.create!(
        name: restaurant[:name], 
        address: restaurant[:address],
        rating: restaurant[:rating],
        user_ratings_total: restaurant[:user_ratings_total],
        description: restaurant[:description],
        types: restaurant[:types],
        google_maps_uri: restaurant[:google_maps_uri]
      )
    end
  end
  

end
