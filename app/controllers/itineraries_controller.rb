class ItinerariesController < ApplicationController
  before_action :set_itinerary, only: [:show]

  def index
    @itineraries = current_user.itineraries
  end


  def show
    @selected_attraction = Attraction.find(params[:attraction_id]) if params[:attraction_id]

    @itinerary = Itinerary.find(params[:id])

    @tripadvisor_suggestions = TripadvisorApi.fetch_singapore_attractions

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

  def review
    @itinerary = Itinerary.find(params[:itinerary_id])
    @itinerary_by_day = @itinerary.itinerary_attractions.group_by(&:day)

    @markers = @itinerary.itinerary_attractions.map do |itinerary_attraction|
      {
        lat: itinerary_attraction.attraction.latitude.to_f,
        lng: itinerary_attraction.attraction.longitude.to_f,
        title: itinerary_attraction.attraction.name
        # infoWindow: { content: render_to_string(partial: "/flats/map_box", locals: { flat: flat }) }
        # Uncomment the above line if you want each of your markers to display a info window when clicked
        # (you will also need to create the partial "/flats/map_box")
      }
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
