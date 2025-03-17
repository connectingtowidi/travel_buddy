require 'httparty'

class TripadvisorApi
  include HTTParty
  
  base_uri "https://api.content.tripadvisor.com/api/v1"
  headers accept: 'application/json', referer: ENV["TRIPADVISOR_REFERRER"]

  API_KEY = ENV["TRIPADVISOR_API_KEY"]

  def self.fetch_singapore_attractions(name, latitude, longitude)
    pp "Fetching #{name}"
    attractions_response = get("/location/search", query: {
      key: API_KEY,
      searchQuery: name,
      category: 'attractions',
      language: 'en',
      latLong: "#{latitude},#{longitude}"
    })

    response = {
      "data" => attractions_response["data"] || []
    }

    return [] if response.blank? || response["data"].blank?

    attraction = response["data"][0]
    location_id = attraction["location_id"]

    final_response = begin
      details = fetch_attraction_details(location_id)
      pp "Found #{attraction["name"]}"
      pp "========================"
      {
        "location_id" => location_id,
        "name" => attraction["name"], 
        "photos" => fetch_photos(location_id),
        "reviews" => fetch_reviews(location_id),
        **details
      }
    rescue StandardError => e
      Rails.logger.error("Failed to fetch details for attraction #{location_id}: #{e.message}")
      nil
    end

    [final_response].compact
  end

  def self.fetch_attraction_details(location_id)
    response = get("/location/#{location_id}/details", query: {
      key: API_KEY,
      language: 'en',
      currency: 'SGD'
    })

    response.merge({
      "address" => response["address_obj"],
      "description" => response["description"],
      "duration" => response["duration"],
    })
  end

  def self.fetch_photos(location_id)
    response = get("/location/#{location_id}/photos", query: {
      key: API_KEY,
      language: 'en',
      limit: 20
    })
    
    response["data"]&.first(20)&.map { |photo| photo["images"]["large"]["url"] } || []
  end

  def self.fetch_reviews(location_id)
    response = get("/location/#{location_id}/reviews", query: {
      key: API_KEY,
      language: 'en',
      limit: 20
    })

    response["data"]&.first(20)&.map { |review| { title: review["title"], text: review["text"] } } || []
  end

  def self.fetch_location_details(location_id)
    response = get("/location/#{location_id}/details", query: {
      key: API_KEY,
      language: 'en',
      currency: 'SGD'
    })
    
    handle_response(response)
  end

  private

  def self.handle_response(response)
    unless response.success?
      Rails.logger.error("Tripadvisor API Error: #{response.code} - #{response.body}")
      return {}
    end
    response
  rescue StandardError => e
    Rails.logger.error("Tripadvisor API Error: #{e.message}")
    {}
  end
end
