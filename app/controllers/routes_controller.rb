require 'httparty'

class RoutesController < ApplicationController
  def get_route(origin, destination)
    origin = GoogleMapsService.geocode_address(origin) # Example: "37.419734,-122.0827784"
    destination = GoogleMapsService.geocode_address(destination) # Example: "37.417670,-122.079595"

    api_key = Rails.application.credentials.dig(:google_maps, :api_key)
    google_url = "https://maps.googleapis.com/maps/api/directions/json"

    response = HTTParty.get(google_url, query: {
      origin: origin,
      destination: destination,
      mode: "driving",
      key: api_key
    })

    if response.success?
      render json: response.parsed_response
    else
      render json: { error: "Failed to fetch route" }, status: :bad_request
    end
  end

  private

  def travel_params
    params.require(:travel).permit(:travel_mode)
  end
end
