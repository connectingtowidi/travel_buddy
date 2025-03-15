require 'httparty'
require 'json'
require "open-uri"

class GoogleMapsService

  include HTTParty
  
  BASE_URL = "https://maps.googleapis.com/maps/api"
  ROUTE_URL = "https://routes.googleapis.com/directions/v2:computeRoutes"
  API_KEY = ENV["GOOGLE_MAPS_API_KEY"]

  # Get geolocation for an address
  def self.geocode_address(address)
    # url = https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=YOUR_API_KEY
    url = URI("#{BASE_URL}/geocode/json?address=#{URI.encode_www_form_component(address)}&key=#{API_KEY}")
    address_serialized = URI.parse(url).read
    address_details = JSON.parse(address_serialized)["results"][0]
    # place_id = address["place_id"]
    # place_id
  end

  # def self.fetch_markers
  #   # Normally, this would fetch data from a database or an external API.
  #   # Example: Location.all.map { |loc| { lat: loc.latitude, lng: loc.longitude, info_window: loc.name } }
  #   url = URI("#{BASE_URL}/geocode/json?address=#{URI.encode_www_form_component(address)}&key=#{API_KEY}")
  #   url_serialized = URI.parse(url).read
  #   url_details = JSON.parse(address_serialized)["results"][0]
  #   [
  #     { lat: 37.7749, lng: -122.4194, info_window: "San Francisco" },
  #     { lat: 34.0522, lng: -118.2437, info_window: "Los Angeles" }
  #   ]
  # end

  def self.create_travel(origin, destination, mode)
    response = HTTParty.post(
      ROUTE_URL,
      headers: {
        "Content-Type" => "application/json",
        "X-Goog-Api-Key" => API_KEY,
        "X-Goog-FieldMask" => "routes.duration,routes.distanceMeters,routes.legs,routes.polyline.encodedPolyline"
      },
      body: {
        
          "origin":{
            "location":{
              "latLng":{
                "latitude": origin.latitude,
                "longitude": origin.longitude
              }
            }
          },
          "destination":{
            "location":{
              "latLng":{
                "latitude": destination.latitude,
                "longitude": destination.longitude
              }
            }
          },
          "travelMode": mode,
          "computeAlternativeRoutes": false,
          "languageCode": "en-US",
          "units": "IMPERIAL"
      }.to_json
    )

    data = JSON.parse(response.body) if response.success?

    { error: "Failed to fetch route", status: response.code, message: response.body }
  
    return data
  end
end

