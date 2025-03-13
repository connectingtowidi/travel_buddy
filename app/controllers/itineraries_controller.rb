class ItinerariesController < ApplicationController
  before_action :set_itinerary, only: [:show]

  def index
    @itineraries = current_user.itineraries
  end

  def show
    @selected_attraction = Attraction.find(params[:attraction_id]) if params[:attraction_id]

    @itinerary = Itinerary.find(params[:id])

    # Preventing running of the Tripadvisor API every time the page is loaded
    # @tripadvisor_suggestions = TripadvisorApi.fetch_singapore_attractions

    @tripadvisor_suggestions = Attraction.where.not(last_tripadvisor_update: nil)
                                       .where.not(name: nil)
                                       .where.not(location_id: nil)
                                       .order(last_tripadvisor_update: :desc)
                                       .limit(20)

    # Create a hash to store travel durations and transport modes
    @travel_durations = {}
    @transport_modes = {}

    @itinerary.itinerary_attractions.each_with_index do |itinerary_attraction, index|
      if index < @itinerary.itinerary_attractions.size - 1
        # Find the corresponding travel record
        travel = Travel.find_by(
          itinerary_attraction_from_id: itinerary_attraction.id,
          itinerary_attraction_to_id: @itinerary.itinerary_attractions[index + 1].id
        )

        if travel
          @travel_durations[itinerary_attraction.id] = travel.itinerary_attraction_from_id
          @transport_modes[itinerary_attraction.id] = travel.mode
        end
      end
    end
  end

  def new
    @itinerary = Itinerary.new
  end

  def create
    @itinerary = GenerateItineraryService.(
     current_user, 
      itinerary_params[:interest], 
      itinerary_params[:start_date], 
      itinerary_params[:end_date], 
      itinerary_params[:pax]
    )


  if @itinerary.save!
    redirect_to itinerary_path(@itinerary), notice: "Itinerary was successfully created."
  else
    render :new, status: :unprocessable_entity
  end
end


 private

  
  def itinerary_params
    params.require(:itinerary).permit(:interest, :start_date, :end_date, :pax, :number_of_pax)
  end

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
  end

end
