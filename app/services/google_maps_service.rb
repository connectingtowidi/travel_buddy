require 'httparty'

class GoogleMapsService
    include HTTParty
    
    BASE_URL = "https://maps.googleapis.com/maps/api/directions/json"

    API_KEY = ENV["TRIPADVISOR_API_KEY"]

    def initialize
        @api_key = ENV["GOOGLE_MAPS_API_KEY"]
    end

    def get_directions(origin, destination)
    # Build the URL with the origin, destination, and API key
    url = "#{BASE_URL}?origin=#{origin}&destination=#{destination}&key=#{@api_key}"

    # Make the GET request to Google Maps Directions API using httparty
    response = HTTParty.get(url)

    # Parse the response from JSON into a Ruby Hash
    directions = response.parsed_response

    # Return the parsed directions data
    directions
  end
end