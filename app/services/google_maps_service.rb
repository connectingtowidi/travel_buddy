require 'httparty'

class GoogleMapsService
    include HTTParty

    base_uri 'https://maps.googleapis.com/maps/api/place'

    def initialize
        @api_key = ENV["GOOGLE_MAPS_API_KEY"]
    end
    
    
end