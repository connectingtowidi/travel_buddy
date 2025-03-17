require 'httparty'

class RestaurantRecommendationService
  include HTTParty
  
  BASE_URL = "https://places.googleapis.com/v1/places:searchNearby"
  API_KEY = ENV["GOOGLE_MAPS_API_KEY"]

  def self.get_recommendations(latitude:, longitude:, dietary_preferences: [])
    response = HTTParty.post(
      BASE_URL,
      headers: {
        "Content-Type" => "application/json",
        "X-Goog-Api-Key" => API_KEY,
        "X-Goog-FieldMask" => "places.displayName,places.formattedAddress,places.rating,places.priceLevel,places.editorialSummary,places.types,places.userRatingCount,places.googleMapsUri"
      },
      body: {
        locationRestriction: {
          circle: {
            center: {
              latitude: latitude,
              longitude: longitude
            },
            radius: 1200.0  # Search within 1.2km radius
          }
        },
        # TODO: explore https://developers.google.com/maps/documentation/places/web-service/place-types#food-and-drink
        includedTypes: ["restaurant"],
        maxResultCount: 5
      }.to_json
    )

    return { error: "Failed to fetch recommendations", status: response.body } unless response.success?

    restaurants = JSON.parse(response.body)["places"] || []
  
    restaurants.map do |restaurant|
      {
        name: restaurant.dig("displayName", "text"),
        address: restaurant["formattedAddress"],
        rating: restaurant["rating"],
        user_ratings_total: restaurant["userRatingCount"],
        description: restaurant.dig("editorialSummary", "text"),
        types: restaurant["types"],
        google_maps_uri: restaurant["googleMapsUri"]
      }
    end
  end
end 