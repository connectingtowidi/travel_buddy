require 'httparty'
require 'json'
require "open-uri"

class GoogleMapsService

  include HTTParty
  
  BASE_URL = "https://maps.googleapis.com/maps/api"
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

  def self.get_route(origin, destination)
    uri = URI("#{BASE_URL}/directions/json?origin=#{origin}&destination=#{destination}&mode=driving&key=#{API_KEY}")
    
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    if data["status"] == "OK"
      route = data["routes"].first
      {
        polyline: route["overview_polyline"]["points"],
        distance: route["legs"][0]["distance"]["text"],
        duration: route["legs"][0]["duration"]["text"]
      }
    else
      nil
    end
  end
  
  # Fetch nearby places (e.g., restaurants, attractions)
  # def self.nearby_search(lat, lng, type)
  #   url = URI("#{BASE_URL}/place/nearbysearch/json?location=#{lat},#{lng}&radius=5000&type=#{type}&key=#{@api_key}")
  #   make_request(url)
  # end

  # private

  # def self.make_request(url)
  #   response = Net::HTTP.get(url)
  #   JSON.parse(response)
  # rescue StandardError => e
  #   Rails.logger.error "Google Maps API Error: #{e.message}"
  #   nil
  # end
end

