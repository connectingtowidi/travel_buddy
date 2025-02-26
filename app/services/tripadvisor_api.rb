require 'uri'
require 'net/http'
require 'json'

class TripadvisorService
  BASE_URL = "https://api.content.tripadvisor.com/api/v1"
  API_KEY = ENV["TRIPADVISOR_API_KEY"] # Store your API key in ENV

  def self.fetch_singapore_attractions
    url = URI("#{BASE_URL}/location/search?key=#{API_KEY}&searchQuery=Singapore&category=attractions&language=en")

    response = make_request(url)
    return [] if response.blank? || response["data"].blank?

    # Fetch details for the top 3 attractions
    response["data"][0..2].map do |attraction|
      location_id = attraction["location_id"]
      begin
        details = fetch_attraction_details(location_id)
        {
          name: attraction["name"],
          address: details["address"],
          description: details["description"],
          duration: details["duration"],
          photos: fetch_photos(location_id),
          reviews: fetch_reviews(location_id)
        }
      rescue StandardError => e
        Rails.logger.error("Failed to fetch details for attraction #{location_id}: #{e.message}")
        nil
      end
    end.compact
  end

  def self.fetch_attraction_details(location_id)
    url = URI("#{BASE_URL}/location/#{location_id}/details?key=#{API_KEY}&language=en")
    response = make_request(url)
    {
      "address" => response["address_obj"],
      "description" => response["description"],
      "duration" => response["duration"]
    }
  end

  def self.fetch_photos(location_id)
    url = URI("#{BASE_URL}/location/#{location_id}/photos?key=#{API_KEY}&language=en&limit=3")
    response = make_request(url)

    response["data"]&.first(3)&.map { |photo| photo["images"]["large"]["url"] } || []
  end

  def self.fetch_reviews(location_id)
    url = URI("#{BASE_URL}/location/#{location_id}/reviews?key=#{API_KEY}&language=en&limit=3")
    response = make_request(url)

    response["data"]&.first(3)&.map { |review| { title: review["title"], text: review["text"] } } || []
  end

  private

  def self.make_request(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.read_timeout = 10  # Add timeout
    http.open_timeout = 10  # Add timeout

    request = Net::HTTP::Get.new(url)
    request["accept"] = "application/json"

    response = http.request(request)
    
    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error("Tripadvisor API Error: #{response.code} - #{response.body}")
      return {}
    end

    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error("Tripadvisor API Error: #{e.message}")
    {}
  end
end
