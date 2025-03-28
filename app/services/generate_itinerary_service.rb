require "json"

class GenerateItineraryService
  SYSTEM_PROMPT = <<~SYSTEM_PROMPT
    You are a helpful and knowledgeable travel planner specializing in designing personalized travel itineraries for Singapore. Your role is to recommend suitable destinations, hotels, flights, activities, transportation options, local restaurants, and travel tips based on the user's needs.

    When crafting the itinerary, ensure the following:

    Attraction Operating Hours
    Respect the opening and closing hours of each attraction when deciding its placement in the itinerary.
    Attraction-specific Recommendations
    Incorporate additional attraction information where available.
    For example:
    If the attraction recommends spending 3 hours, allocate at least 3 hours.
    If the attraction is recommended for evenings, schedule it during evening hours.
    Avoid Repetitions
    Do not repeat attractions across different days.
    An attraction scheduled on Day 1 must not appear again on Day 2 or later.

    Follow these steps when building the itinerary:
    Attraction Filtering
    Select attractions based on:
    a) Opening hours
    b) Recommended visit duration or timing
    c) Avoiding repetitions
    Optimal Route Planning
    Use the attractions' address, latitude and longitude to minimize travel distance or time.
    You may use the Nearest Neighbor Algorithm:
    Start from the given starting location.
    Select the nearest unvisited attraction.
    Move to that location and mark it as visited.
    Repeat until all attractions are visited.
    The start and end points do not have to be the same unless specified.
    Attraction Grouping
    Group attractions into daily itineraries based on the optimized route.
  SYSTEM_PROMPT

  def self.call(current_user, inputs = {})
    attractions = get_nearest_attractions(inputs[:interest])
    start_date, end_date, duration = parse_date_strings(inputs[:start_date], inputs[:end_date])
    user_prompt = generate_user_prompt(attractions, start_date, end_date, duration)
    messages = generate_messages_for_ai(user_prompt)
    response_format = get_response_format(duration)
    itinerary_data = AiService.get_response_from_ai(response_format, messages)
    create_itinerary(current_user, itinerary_data, inputs)
  end

  def self.create_itinerary(current_user, itinerary_data, inputs = {})
    itinerary = Itinerary.create!(
      name: itinerary_data["itinerary_name"],
      remark: itinerary_data["remarks"],
      duration: inputs[:duration],
      user: current_user,
      interest: inputs[:interest],
      number_of_pax: inputs[:number_of_pax],
      dietary_preferences: inputs[:dietary_preferences],
      start_date: Date.parse(inputs[:start_date]),
      end_date: Date.parse(inputs[:end_date])
    )

    create_itinerary_attractions(itinerary_data, itinerary)
    itinerary
  end

  def self.create_itinerary_attractions(itinerary_data, itinerary)
    valid_attractions = get_valid_attractions(itinerary_data)

    valid_attractions.each do |attraction|
      itinerary_attraction = ItineraryAttraction.new(
        itinerary: itinerary,
        attraction_id: attraction["id"],
        day: attraction["day"],
        duration: attraction["duration"],
        starting_time: Time.parse(attraction["starting_time"]) - 8.hours
      )

        unless itinerary_attraction.save
          Rails.logger.warn("Failed to create itinerary attraction: #{itinerary_attraction.errors.full_messages.join(', ')}")

        end
    end
  end

  def self.get_valid_attractions(itinerary_data)
    attraction_ids_to_test = itinerary_data["attractions"].map { |attraction| attraction["id"] }
    valid_attraction_ids = Attraction.where(id: attraction_ids_to_test).pluck(:id)
    itinerary_data["attractions"].select { |attraction| valid_attraction_ids.include?(attraction["id"]) }
  end

  def self.get_nearest_attractions(interest)
    input = "Give me a list of attractions that match the interest: #{interest}"
    response = AiService.generate_embeddings(input)
    if response
      Attraction.nearest_neighbors(
        :embedding, response,
        distance: "euclidean"
      ).first(12)
    else
      []
    end
  end

  def self.generate_messages_for_ai(user_prompt)
    [
      { role: "system", content: SYSTEM_PROMPT },
      { role: "user", content: user_prompt }
    ]
  end

  def self.generate_user_prompt(attractions, start_date, end_date, duration)
    attractions_json = attractions_to_json(attractions)

    <<~USER_PROMPT
      Given a list of attractions, generate an itinerary for a #{duration} day trip to Singapore from #{start_date} to #{end_date}.
      You don't need to use the entire list of attractions, prioritize the most popular ones.

      Attractions:
      ###
      #{attractions_json}
      ###
    USER_PROMPT
  end

  def self.parse_date_strings(start_date_string, end_date_string)
    start_date = Date.parse(start_date_string)
    end_date = Date.parse(end_date_string)
    duration = (end_date - start_date).to_i + 1
    [start_date, end_date, duration]
  end

  def self.attractions_to_json(attractions)
    # We only send certain attraction information to increase relevance and to save cost
    attractions.as_json(
      only: %I[
        id name description address_string reviews price rating num_reviews
        trip_types weekday_text latitude longitude
      ]
    ).to_json
  end

  def self.get_response_format(duration)
    {
      type: "json_schema",
      json_schema: {

        name: "attractions",
        strict: false,
        schema: {
          type: "object",
          properties: {
            itinerary_name: {
              type: "string",
              description: "A one liner name for the itinerary planned"
            },
            remarks: {
              type: "string",
              description: "A summary of the attractions included in the itinerary get the user's excited about the trip"
            },
            attractions: {
              type: "array",
              items: {
                type: "object",
                properties: {
                  id: {
                    type: "integer",
                    description: "Unique identifier for the attraction obtained from the user's input"
                  },
                  day: {
                    type: "integer",
                    description: "The day that the user should visit the attraction",
                    minimum: 1,
                    maximum: duration
                  },
                  duration: {
                    type: "integer",
                    description: "The duration that the user should stay at the attraction for",
                    minimum: 1
                  },
                  starting_time: {
                    type: "string",
                    description: "When the date time that user should visit the attraction in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ"
                  }
                },
                required: [
                  "id",
                  "day",
                  "duration",
                  "starting_time"
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
    }
  end
end
