class ItinerariesController < ApplicationController
  before_action :set_itinerary, only: [:show]

  def index
    @itineraries = current_user.itineraries
  end

  def show
    @itinerary.itinerary_attractions = @itinerary.itinerary_attractions.order(:order)
    
    # Create a hash to store travel information between attractions
    @transport_modes = {}
    @travel_durations = {}
    
    # For each attraction, find the travel to the next attraction
    @itinerary.itinerary_attractions.each_with_index do |current_attraction, index|
      if index < @itinerary.itinerary_attractions.size - 1
        next_attraction = @itinerary.itinerary_attractions[index + 1]
        
        # Find the travel between current and next attraction
        travel = Travel.find_by(
          itinerary_attraction_from_id: current_attraction.id,
          itinerary_attraction_to_id: next_attraction.id
        )
        
        # Store the mode (default to "foot" if no travel record exists)
        @transport_modes[current_attraction.id] = travel&.mode || "foot"
        
        # For now, using hardcoded 15 mins, but you could store actual durations in your Travel model
        @travel_durations[current_attraction.id] = 15
      end
    end
    
    # Default transport mode as fallback
    @default_transport_mode = "foot"
  end

  
  def new
  end

  def create
    @itinerary = Itinerary.new(itinerary_params)
    @itinerary.user = current_user
    if @itinerary.save
      redirect_to itinerary_path(@itinerary)
    else
      render :new
    end
  end
  
  private

  def itinerary_params 
    params.require(:itinerary).permit(:name, :description, :start_date, :end_date)
  end    

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
  end
end
