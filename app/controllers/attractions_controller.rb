# app/controllers/attractions_controller.rb

class AttractionsController < ApplicationController
  def index
    attractions = TripadvisorApi.fetch_singapore_attractions
    render json: attractions
  end

  def show
    @attraction = Attraction.find_by(id: params[:id])
    
    if @attraction.nil?
      flash[:alert] = "Attraction not found"
      redirect_to attractions_path and return
    end
    
    # Set selected attraction for the view
    @selected_attraction = @attraction
    
    # If coming from an itinerary, save itinerary info for "Back" button
    if params[:itinerary_id].present?
      @itinerary = Itinerary.find_by(id: params[:itinerary_id])
    end
  end
  
  def generate
    @tripadvisor_suggestions = TripadvisorApi.fetch_singapore_attractions
    # @tripadvisor_suggestions = JSON.parse(File.read(Rails.root.join('app', 'controllers', 'temp_tripadvisor_results.json')))
      
    # Fetch additional details for each attraction
     
    # @tripadvisor_details = @tripadvisor_suggestions.map { 
    #   |attraction_data| 
    #   [attraction_data[:location_id].to_sym, 
    #   TripadvisorApi.fetch_location_details(attraction_data[:location_id].to_sym)] }.to_h
    @tripadvisor_details = {}

      @tripadvisor_suggestions.each do |attraction_data|
        
        location_id = attraction_data["location_id"]
        
        @tripadvisor_details[location_id] = TripadvisorApi.fetch_location_details(location_id)
        
        # Get the details for this attraction using the location_id as a symbol key
        details = @tripadvisor_details[location_id]
      
        # Skip if no details found
        # next unless details

        # Skip if required data is missing
        # next unless attraction_data[:address] && attraction_data[:name]
        
        attraction = Attraction.find_or_initialize_by(location_id: details["location_id"])

        # Update or set attributes
        attraction.assign_attributes(
          address_string: attraction_data["address"]["address_string"],
          description: attraction_data["description"], 
          opening_hour: Time.strptime(details["hours"]&.dig("periods", 0, "open", "time") || '0000', '%H%M'),
          closing_hour: Time.strptime(details["hours"]&.dig("periods", 0, "close", "time") || '0000', '%H%M'),
          duration: details["duration"],
          location_id: details["location_id"],
          rating: details["rating"].to_f,
          num_reviews: details["num_reviews"].to_i,
          rating_image_url: details["rating_image_url"],
          trip_types: details["trip_types"].max_by { |t| t["value"].to_i }["localized_name"],
          weekday_text: details["hours"]&.dig("weekday_text"),
          latitude: details["latitude"].to_f,
          longitude: details["longitude"].to_f,
          email: details["email"],
          website: details["website"],
          reviews: attraction_data["reviews"]&.map { |r| {title: r["title"], text: r["text"]} },
          tripadvisor_photos: attraction_data["photos"],
          phone: details["phone"],
        )
        attraction.save!
      end
      # Attraction.destroy_all
      
      render json: { 
        attractions: @tripadvisor_suggestions,
        details: @tripadvisor_details,
        status: 'success'
      }
  end  
end



