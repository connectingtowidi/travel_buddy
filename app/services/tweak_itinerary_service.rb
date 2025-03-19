require "openai"
require "json"

class TweakItineraryService
  def self.call(user_prompt:, locked_attractions:, itinerary:)
    client = OpenAI::Client.new

    locked_attractions = locked_attractions.to_json(only: [:id, :name])
    new_recommendations = nearest_attractions(user_prompt).to_json(only: [:id, :name])
    random_recommendations = Attraction.order("RANDOM()").take(5).to_json(only: [:id, :name])
    recommendations = new_recommendations + random_recommendations

    current_attractions = itinerary.attractions.to_json(only: [:id, :name])

    prompt = <<~PROMPT
      You are a Singapore travel planner helping to modify the current itinerary based on user request: #{user_prompt}.
      The attractions in the current itinerary are #{current_attractions}.
      The new modified itinerary must include #{locked_attractions}. 
      You may choose to include #{recommendations} in the new itinerary if it makes sense for the user request.
      Try not to remove any existing attractions from the current itinerary unless it is absolutely necessary to accommodate the new attractions.
      Keep it to a #{itinerary.duration} day trip.

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
                itinerary_name: {
                  type: "string",
                  description: "The name of the itinerary"
                },
                remarks: {
                  type: "string",
                  description: "A summary of the attractions included in the itinerary"
                },
                attractions: {
                  type: "array",
                  items: {
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
                        maximum: 10
                      },
                      duration: {
                        type: "integer",
                        description: "How long I should stay at the attraction for in hours",
                        minimum: 1
                      },
                      starting_time: {
                        type: "string",
                        description: "The start time at the attraction in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ"
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
              required: [
                "itinerary_name",
                "remarks",
                "attractions"
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

    itinerary.update!(
      name: itinerary_data["itinerary_name"],
      remark: itinerary_data["remarks"]
    )

    itinerary.itinerary_attractions.destroy_all

    valid_attraction_ids = Attraction.where(id: itinerary_data["attractions"].map { |a| a["id"] }).pluck(:id)
    valid_attractions = itinerary_data["attractions"].select { |a| valid_attraction_ids.include?(a["id"]) }

    valid_attractions.each do |attraction|
      itinerary_attraction = ItineraryAttraction.new(
        itinerary_id: itinerary.id,
        attraction_id: attraction["id"],
        day: attraction["day"],
        duration: attraction["duration"],
        starting_time: Time.parse(attraction["starting_time"]) - 8.hours
      )
    
      unless itinerary_attraction.save
        Rails.logger.warn("Failed to create itinerary attraction: #{itinerary_attraction.errors.full_messages.join(', ')}")

      end
    end

    itinerary
  end


  private

  def self.client
    @client ||= OpenAI::Client.new
  end


  def self.nearest_attractions(interest)
      response = self.client.embeddings(
        parameters: {
          model: 'text-embedding-3-small',
          input: "Give me a list of attractions that match the interest: #{interest}"
        }
      )
      if response && response['data']
        question_embedding = response['data'][0]['embedding']
        Attraction.nearest_neighbors(
          :embedding, question_embedding,
          distance: "euclidean"
        ).first(12)
      else
        []
      end
  end
end
