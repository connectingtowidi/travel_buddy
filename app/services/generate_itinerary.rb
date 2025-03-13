require "openai"
require "json"

class GenerateItinerary
  def self.call(user, interest, start_date, end_date, number_of_pax)
    client = OpenAI::Client.new


    attractions = self.nearest_attractions(interest)
    attractions_json = attractions.to_json
    duration = (end_date - start_date).to_i # Calculate duration in days

    prompt = <<~PROMPT
      You are a travel planner. You are given a list of attractions in Singapore.
      You are to generate an itinerary for a #{duration} day trip to Singapore
      The itinerary should be in JSON format.
      The itinerary should include the id of the attraction, the day that I should visit the attraction,
      and the duration of the visit, and the starting time, make sure the starting time falls within attraction's 
      opening and closing hours for the day and make sure the #{start_date} and #{end_date} fall within the opening days
      of the attractions.
      The itinerary should include all the attractions and give it suitable name for the itinerary

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
                itinerary_name: {
                  type: "string",
                  description: "The name of the itinerary"
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
                        maximum: duration
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
                "attractions",
                "itinerary_name"
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

    pp response_content
    # Ensure the response is parsed correctly
    itinerary_data = JSON.parse(response_content) rescue {}


    pp itinerary_data

    itinerary = Itinerary.create!(
      name: itinerary_data["itinerary_name"],
      duration: duration,
      user: user,
      interest: interest,
      number_of_pax: number_of_pax
      start_date: start_date,
      end_date: end_date
    )

    itinerary_data["attractions"].each do |attraction|
      ItineraryAttraction.create!(
        itinerary: itinerary,
        attraction_id: attraction["id"],
        day: attraction["day"],
        duration: attraction["duration"],
        starting_time: attraction["starting_time"]

      )
    end
  end

  private

  def self.client
    @client ||= OpenAI::Client.new
  end

  
  def nearest_attractions(interest)
    response = self.client.embeddings(
      parameters: {
        model: 'text-embedding-3-small',
        input: "Give me all the attractions that match the #{interest}"
      }
    )
    question_embedding = response['data'][0]['embedding']
    return Attraction.nearest_neighbors(
      :embedding, question_embedding,
      distance: "euclidean"
    ) # you may want to add .first(3) here to limit the number of results
  end

end
