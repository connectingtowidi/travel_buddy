namespace :gov_attractions do
  desc "Merge TripAdvisor and DataGov attractions"
  task merge: :environment do
    pp "CAREFUL: This makes ~300 API requests to TripAdvisor API. USE SPARINGLY."
    Attraction.find_each do |attraction|
      trip_advisor_data_file = Rails.root.join('lib', 'tasks', 'trip_advisor_data.json')
      trip_advisor_data = JSON.parse(File.read(trip_advisor_data_file)) rescue {}
      
      fetched_data = nil

      if trip_advisor_data[attraction.name].present?
        pp "[LOADING FROM FILE]"
        fetched_data = trip_advisor_data[attraction.name]
      else
        return # just to be safe
        fetched_data = TripadvisorApi.fetch_singapore_attractions(attraction.name, attraction.latitude, attraction.longitude)
        trip_advisor_data[attraction.name] = fetched_data
        File.write('lib/tasks/trip_advisor_data.json', JSON.pretty_generate(trip_advisor_data))
      end
      
      pp "Processed attraction #{attraction.id}: #{attraction.name}"

      if fetched_data.present?
        attraction_data = fetched_data.first

        attraction.assign_attributes({
          name: attraction_data["name"],
          address_string: attraction_data.dig("address", "address_string"),
          description: attraction_data["description"].presence || attraction.description,
          opening_hour: Time.strptime(attraction_data.dig("hours", "periods", 0, "open", "time") || '0000', '%H%M'),
          closing_hour: Time.strptime(attraction_data.dig("hours", "periods", 0, "close", "time") || '0000', '%H%M'),
          duration: attraction_data["duration"],
          rating: attraction_data["rating"].to_f,
          num_reviews: attraction_data["num_reviews"].to_i,
          rating_image_url: attraction_data["rating_image_url"],
          weekday_text: attraction.weekday_text.present? ? attraction.weekday_text : attraction_data.dig("hours", "weekday_text"),
          email: attraction_data["email"],
          website: attraction_data["website"],
          reviews: attraction_data["reviews"]&.map { |r| {title: r["title"], text: r["text"]} } || [],
          tripadvisor_photos: attraction_data["photos"] || attraction.tripadvisor_photos || [],
          phone: attraction_data["phone"],
          latitude: attraction_data["latitude"].to_f,
          longitude: attraction_data["longitude"].to_f,
          last_tripadvisor_update: Time.current
        }.compact)

        attraction.save
      end
    end
  end

  desc "Clean data using OpenAI" 
  task clean: :environment do
    client = OpenAI::Client.new

    Attraction.find_each do |attraction|
      # Skip if no weekday_text or it's already in the correct format
      if attraction.weekday_text.present? && !attraction.weekday_text.is_a?(Array)
        # Format weekday_text into an array with proper format
         response = client.chat(
            parameters: {
              model: "gpt-4o-mini",
              response_format: {
                type: "json_schema", 
                json_schema: {
                  name: "opening_hours",
                  strict: false,
                  schema: {
                    type: "object",
                    properties: {
                      remarks: {
                        type: "string",
                        description: "Remarks if any"
                      },
                      monday: {
                        type: "string",
                        description: "Opening hours for Monday"
                      },
                      tuesday: {
                        type: "string",
                        description: "Opening hours for Tuesday"
                      },
                      wednesday: {
                        type: "string",
                        description: "Opening hours for Wednesday"
                      },
                      thursday: {
                        type: "string",
                        description: "Opening hours for Thursday"
                      },
                      friday: {
                        type: "string",
                        description: "Opening hours for Friday"
                      },
                      saturday: {
                        type: "string",
                        description: "Opening hours for Saturday"
                      },
                      sunday: {
                        type: "string",
                        description: "Opening hours for Sunday"
                      }
                    },
                    required: ["remarks", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
                  },
                }
              },
              messages: [
                {
                  role: "user",
                  content: "Please convert the following opening hours text into a properly formatted array of strings, with one entry per day of the week (Monday through Sunday). Each entry should follow the format 'Day: opening hours'. If a day is closed, indicate it as 'Day: Closed'. Input text: #{attraction.weekday_text}"
                }
              ]
            }
          )
          new_weekday_text = response.dig("choices", 0, "message", "content")
          new_weekday_text = JSON.parse(new_weekday_text) rescue []
          
          pp new_weekday_text.values
          attraction.update(weekday_text: new_weekday_text.values)
      end
  
      # # Generate trip_types based on attraction description
      if attraction.description.present?
        response = client.chat(
          parameters: {
            model: "gpt-4o-mini",
            response_format: {
              type: "json_schema",
              json_schema: {
                name: "trip_types",
                strict: false,
                schema: {
                  type: "object",
                  properties: {
                    categories: {
                      type: "array",
                      items: {
                        type: "string"
                      },
                    }
                  }
                }
              }
            },
            messages: [
              {
                role: "user",
                content: "Categorize into one or more of these trip types: Kids-focused, Culture, Food, Nature, Shopping. Only return trip types that strongly match this attraction: #{attraction.name}, #{attraction.description}"
              }
            ]
          }
        )

        new_trip_types = response.dig("choices", 0, "message", "content")
        new_trip_types = JSON.parse(new_trip_types)
        
        attraction.update(labels: new_trip_types["categories"])
      end
    end

    Attraction.where(weekday_text: "").update_all(weekday_text: [])
  end

  desc "Update attractions from DataGov API"
  task update: :environment do
    ItineraryAttraction.delete_all
    Attraction.delete_all

    file_path = Rails.root.join('lib', 'tasks', 'gov_data.json')
    attractions = JSON.parse(File.read(file_path))
    
    attractions.each do |attraction_data|
      doc = Nokogiri::HTML(attraction_data["properties"]["Description"])
      data = {}
      doc.css('tr').each do |row|
        cells = row.css('th, td')
        next unless cells.length == 2
        
        key = cells[0].text.strip
        value = cells[1].text.strip
        data[key] = value
      end
      location_id = attraction_data["properties"]["Name"].to_s.scan(/\d+/).first.to_i
      attraction = Attraction.find_or_initialize_by(location_id: location_id)
      
      attraction.assign_attributes({
        name: data["PAGETITLE"],
        address_string: data["ADDRESS"],
        description: data["OVERVIEW"],
        weekday_text: data["OPENING_HOURS"],
        latitude: data["LATITUDE"].to_f,
        longitude: data["LONGTITUDE"].to_f,
        website: data["URL_PATH"] || data["EXTERNAL_LINK"],
        tripadvisor_photos: [data["IMAGE_PATH"]],
        last_tripadvisor_update: Time.current
      }.compact)
      
      
      if attraction.save
        pp "Saved #{attraction.name}"
      else
        pp "Failed to save #{attraction.name}"
      end
    end
  end
end
