require 'httparty'

class TripadvisorApi
  include HTTParty
  
  base_uri "https://api.content.tripadvisor.com/api/v1"
  headers accept: 'application/json', referer: ENV["TRIPADVISOR_REFERRER"]

  API_KEY = ENV["TRIPADVISOR_API_KEY"]

  def self.fetch_singapore_attractions
    attractions_response = get("/location/search", query: {
      key: API_KEY,
      searchQuery: 'singapore',
      category: 'attractions',
      language: 'en'
    })

    restaurants_response = get("/location/search", query: {
      key: API_KEY,
      searchQuery: 'singapore', 
      category: 'restaurants',
      language: 'en'
    })

    # Combine the responses
    response = {
      "data" => (attractions_response["data"] || []) + (restaurants_response["data"] || [])
    }

    return [] if response.blank? || response["data"].blank?

    # Fetch details for the top 20 attractions
    response["data"][0..20].map do |attraction|
      location_id = attraction["location_id"]
      begin
        details = fetch_attraction_details(location_id)
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
    end.compact
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
