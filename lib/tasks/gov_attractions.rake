namespace :gov_attractions do
  desc "Update attractions from DataGov API"
  task update: :environment do
    begin
      file_path = Rails.root.join('lib', 'tasks', 'gov_data.json')
      attractions = JSON.parse(File.read(file_path))
      
      attractions.each do |attraction_data|
        attraction = Attraction.find_or_initialize_by(location_id: attraction_data["location_id"])
        
        begin
          attraction.assign_attributes({
            name: attraction_data["name"],
            address_string: attraction_data.dig("address", "address_string"),
            description: attraction_data["description"],
            opening_hour: Time.strptime(attraction_data.dig("hours", "periods", 0, "open", "time") || '0000', '%H%M'),
            closing_hour: Time.strptime(attraction_data.dig("hours", "periods", 0, "close", "time") || '0000', '%H%M'),
            duration: attraction_data["duration"],
            # location_id: attraction_data["location_id"],
            rating: attraction_data["rating"].to_f,
            num_reviews: attraction_data["num_reviews"].to_i,
            rating_image_url: attraction_data["rating_image_url"],
            trip_types: attraction_data["trip_types"]&.max_by { |t| t["value"].to_i }&.dig("localized_name"),
            weekday_text: attraction_data.dig("hours", "weekday_text"),
            latitude: attraction_data["latitude"].to_f,
            longitude: attraction_data["longitude"].to_f,
            email: attraction_data["email"],
            website: attraction_data["website"],
            reviews: attraction_data["reviews"]&.map { |r| {title: r["title"], text: r["text"]} } || [],
            tripadvisor_photos: attraction_data["photos"] || [],
            phone: attraction_data["phone"],
            last_tripadvisor_update: Time.current
          }.compact)
          
          
          if attraction.save
          else
          end
        rescue => e
         
        end
      end
    end
  end
end
