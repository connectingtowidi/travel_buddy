require "openai"
require "json"

class GenerateItinerary
  def self.call(user, attractions, start_date, end_date)
    client = OpenAI::Client.new(access_token: ENV['OPENAI_KEY'])

    attractions_json = attractions.to_json
    duration = (end_date - start_date).to_i # Calculate duration in days

    prompt = <<~PROMPT
      You are a travel planner. You are given a list of attractions in Singapore.
      You are to generate an itinerary for a #{duration} day trip to Singapore.
      The itinerary should be in JSON format.
      The itinerary should include the name of the attraction, 
      the address, and the duration of the visit.
      The itinerary should be in chronological order.

      Here is the list of attractions:
      #{attractions_json}
    PROMPT

    open_ai_response = client.chat(
      parameters: {
        model: "gpt-4o",
        messages: [
          { role: "user", content: prompt }
        ]
      }
    )

    response_content = open_ai_response.dig("choices", 0, "message", "content")

    # Ensure the response is parsed correctly
    itinerary_data = JSON.parse(response_content) rescue {}
   
    itinerary = Itinerary.create!(
      name: "Adventure kid friendly",
      duration: duration,
      user: user,
      interest: "kid-focused",
      pace: "relaxed",
      start_date: start_date,
      end_date: end_date
    )

    attractions.each do |attraction|
      ItineraryAttraction.create!(
        itinerary: itinerary,
        attraction: attraction,
        day: find_day_for_attraction(itinerary_data, attraction.name),
        duration: find_duration_for_attraction(itinerary_data, attraction.name)
      )
    end
  end

  private

  def self.client
    @client ||= OpenAI::Client.new(access_token: ENV['OPENAI_KEY'])
  end

  def self.find_day_for_attraction(itinerary_data, attraction_name)
    itinerary_data.dig("itinerary", "days")&.each do |day_data|
      day_number = day_data["day"]
      
      day_data["activities"]&.each do |activity|
        if activity["name"] == attraction_name
          return day_number
        end
      end
    end
    
    return 1 # Default to day 1 if attraction not found
  end

  def self.find_duration_for_attraction(itinerary_data, attraction_name)
    itinerary_data.dig("itinerary", "days")&.each do |day_data|
      day_data["activities"]&.each do |activity|
        if activity["name"] == attraction_name
          return activity["duration"]
        end
      end
    end
    
    return "2 hours" # Default duration if attraction not found
  end
end