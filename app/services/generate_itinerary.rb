require "openai"
require "json"

class GenerateItinerary
  def self.call(user, attractions, start_date, end_date)
    client = OpenAI::Client.new

    attractions_json = attractions.to_json
    duration = (end_date - start_date).to_i # Calculate duration in days

    prompt = <<~PROMPT
      You are a travel planner. You are given a list of attractions in Singapore.

      You are to generate an itinerary for a #{duration} day trip to Singapore.
      The itinerary should be in JSON format.
      The itinerary should include the id of the attraction, the day that I should visit the attraction, and the duration of the visit.
      The itinerary should include all the attractions.

      Here is the list of attractions:
      #{attractions_json}
    PROMPT

    open_ai_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        response_format: {
          type: "json_schema",
          json_schema: {
            name: "attractions",
            strict: false,
            schema: {
              type: "object",
              properties: {
                id: {
                  type: "integer",
                  description: "Unique identifier for the attraction"
                },
                day: {
                  type: "integer",
                  description: "The day number on which the attraction is scheduled",
                  minimum: 1,
                  maximum: duration
                },
                duration: {
                  type: "integer",
                  description: "How long I should stay at the attraction for in hours",
                  minimum: 1
                }
              },
              required: [
                "id",
                "day",
                "duration"
              ]
            }
          }
        },
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

    itinerary_data["itinerary"].each do |attraction|
      ItineraryAttraction.create!(
        itinerary: itinerary,
        attraction_id: attraction["id"],
        day: attraction["day"],
        duration: attraction["duration"].to_s
      )
    end
  end

  def self.client
    @client ||= OpenAI::Client.new
  end
end
