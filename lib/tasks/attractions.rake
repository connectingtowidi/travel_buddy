namespace :attractions do
  desc "Update attractions from TripAdvisor API"
  task update: :environment do
    log_file = Rails.root.join('log', 'cron_log.log')
    logger = Logger.new(log_file)
    
    logger.info "=== Starting attractions update from TripAdvisor at #{Time.current} ==="
    
    begin
      logger.info "Fetching attractions from TripAdvisor API..."
      attractions = TripadvisorApi.fetch_singapore_attractions
      
      # Log the raw API response
      logger.info "Raw API Response: #{attractions.inspect}"
      
      if attractions.nil? || attractions.empty?
        logger.error "No attractions data received from API"
        return
      end
      
      logger.info "Found #{attractions.length} attractions to process"
      
      attractions.each do |attraction_data|
        # Log each attraction's data
        logger.info "Processing attraction data: #{attraction_data.inspect}"
        
        # Skip if we don't have basic required data
        if attraction_data["name"].blank?
          logger.error "Skipping attraction due to missing name"
          next
        end
        
        attraction = Attraction.find_or_initialize_by(location_id: attraction_data["location_id"])
        
        # Log the current state of the attraction
        logger.info "Current attraction state: #{attraction.attributes.inspect}"
        
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
          
          # Log the attributes we're trying to save
          logger.info "Attempting to save with attributes: #{attraction.attributes.inspect}"
          
          if attraction.save
            logger.info "Updated attraction: #{attraction.name} at #{attraction.last_tripadvisor_update}"
          else
            logger.error "Failed to update attraction: #{attraction.errors.full_messages}"
          end
        rescue => e
          logger.error "Error processing attraction: #{e.message}"
          logger.error e.backtrace.join("\n")
        end
      end
      
      # Log summary of updates
      logger.info "=== Update Summary ==="
      logger.info "Total attractions: #{Attraction.count}"
      logger.info "Recently updated: #{Attraction.where('last_tripadvisor_update > ?', 5.minutes.ago).count}"
      logger.info "=== End Summary ==="
      
    rescue StandardError => e
      logger.error "Error updating attractions: #{e.message}"
      logger.error e.backtrace.join("\n")
    end
  end
end
