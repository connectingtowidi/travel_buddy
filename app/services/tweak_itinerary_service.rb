require "openai"
require "json"

class TweakItineraryService
  def self.call(user_prompt:, locked_attractions:, itinerary:)
    client = OpenAI::Client.new

    locked_attractions = locked_attractions.to_json(only: [:id, :name])
    new_recommendations = nearest_attractions(user_prompt).to_json(only: [:id, :name])
    random_recommendations = Attraction.order("RANDOM()").take(5).to_json(only: [:id, :name])

    prompt = <<~PROMPT
      You are a travel planner helping to modify the current itinerary that is being given to you.
      The new modified itinerary must include #{locked_attractions}.
      You are also to generate other #{new_recommendations} related to #{user_prompt}, plus #{random_recommendations}.
      The itinerary should be in JSON format.
      The itinerary should include the id of the attraction, the day that I should visit the attraction, and the duration of the visit.
    PROMPT

    open_ai_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        response_format: "json",
        messages: [
          { role: "system", content: "You are a helpful travel planner." },
          { role: "user", content: prompt }
        ]
      }
    )

    response_content = open_ai_response.dig("choices", 0, "message", "content")

    pp response_content
    # Ensure the response is parsed correctly
    itinerary_data = JSON.parse(response_content) rescue {}

    pp itinerary_data
  # # Parse OpenAI response
      begin
        itinerary_data = JSON.parse(response_content)
      rescue JSON::ParserError => e
        Rails.logger.error("Failed to parse OpenAI response: #{e.message}")
        itinerary_data = {}
      end
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
