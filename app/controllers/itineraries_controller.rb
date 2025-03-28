class ItinerariesController < ApplicationController
  before_action :set_itinerary, only: [:show, :update_with_ai]

  def index
    @itineraries = current_user.itineraries

    if params[:query].present?
      # Use the PgSearch scope for more efficient searching
      @itineraries = @itineraries.search_by_name(params[:query])

      # Alternative: use global_search if you want to include user email in search
      # @itineraries = @itineraries.global_search(params[:query])
    end

    @itineraries = @itineraries.order(start_date: :desc)

     # Handle turbo_frame requests
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace("itineraries_results", partial: "itineraries/itinerary_list") }
    end
  end

  def show
    @itinerary = Itinerary.find(params[:id])

    if params[:attraction_id].present?
      @selected_attraction = Attraction.find_by(id: params[:attraction_id])

      if @selected_attraction.nil?
        flash[:alert] = "The selected attraction could not be found."
        redirect_to itinerary_path(@itinerary) and return
      end
    end

    @grouped_attractions = @itinerary.itinerary_attractions
    .includes(:attraction, :restaurant_recommendations)
    .order(:day)
    .group_by(&:day)


  end

  def new
    @itinerary = Itinerary.new
  end

  def create
    itinerary_params[:dietary_preferences] = itinerary_params[:dietary_preferences].slice!(0)
    @itinerary = GenerateItineraryService.call(current_user, itinerary_params)

    if @itinerary.save!
      redirect_to itinerary_path(@itinerary), notice: "Itinerary was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def review
    @itinerary = Itinerary.find(params[:itinerary_id])

    # @itinerary_by_day = @itinerary.itinerary_attractions.group_by(&:day)

    # @markers = @itinerary.itinerary_attractions.map do |itinerary_attraction|
    #   {
    #     lat: itinerary_attraction.attraction.latitude.to_f,
    #     lng: itinerary_attraction.attraction.longitude.to_f,
    #     title: itinerary_attraction.attraction.name
    #   }
    # end

    @markers = []
    @travels = []

    # travel_map = Travel.where(itinerary_attraction_from_id: @itinerary.itinerary_attractions.pluck(:id)).index_by(&:itinerary_attraction_from_id)

    @itinerary.itinerary_attractions.each do |itinerary_attraction|
      @markers << {
        lat: itinerary_attraction.attraction.latitude.to_f,
        lng: itinerary_attraction.attraction.longitude.to_f,
        title: itinerary_attraction.attraction.name
      }
      # @itinerary_attraction_id = itinerary_attraction_id
      travel = Travel.find_by(itinerary_attraction_from_id: itinerary_attraction.id)

      if travel
        @travels << travel
      end
    end
  end

  def update_with_ai
    user_prompt = params[:ai_prompt]
    locked_attractions_ids = params[:locked_attractions].to_s.split(',').map(&:to_i)

    locked_attractions = Attraction.where(id: locked_attractions_ids)

    TweakItineraryService.(
      user_prompt:,
      locked_attractions:,
      itinerary: @itinerary
    )

    redirect_to itinerary_path(@itinerary), notice: "Itinerary was successfully updated."
  end

  # This is the AJAX request to fetch the route and duration
  def fetch_route
    @travel = Travel.new(travel_params)

    # @travel.itinerary_attraction_from = ItineraryAttraction.find(travel_params[:itinerary_attraction_from_id])
    # @travel.itinerary_attraction_to = ItineraryAttraction.find(travel_params[:itinerary_attraction_to_id])

    respond_to do |format|
      if @travel.save
        travel_data = GoogleMapsService.create_travel(
          @travel.itinerary_attraction_from.attraction,
          @travel.itinerary_attraction_to.attraction,
          @travel.mode
        )

        if travel_data && !travel_data[:error] && travel_data["routes"].present?
          duration_text = travel_data["routes"][0]["duration"]
          # The duration comes back as something like "3600s", so we remove the "s" and convert to integer
          duration = duration_text.gsub("s", "").to_i / 60

          # Calculate start and end travel times
          end_travel_time = @travel.itinerary_attraction_to.starting_time
          start_travel_time = end_travel_time - duration.minutes

          format.json { render json: {
            travel_id: @travel.id,
            itinerary_attraction_from: @travel.itinerary_attraction_from.attraction.name,
            itinerary_attraction_to: @travel.itinerary_attraction_to.attraction.name,
            duration: duration.round(0),
            mode: @travel.mode,
            start_travel_time: start_travel_time,
            end_travel_time: end_travel_time
          } }
        else
          error_message = travel_data[:error] || "No route found"
          format.json { render json: { error: error_message }, status: :unprocessable_entity }
        end
      else
        format.json { render json: { error: @travel.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update_ticket_booking_status
    @itinerary = Itinerary.find(params[:itinerary_id])
    
    respond_to do |format|
      if @itinerary.update(update_ticket_booking_status_params)
        format.html { redirect_to itineraries_path, notice: "Itinerary was successfully updated." }
        flash[:success] = "Your tickets have been successfully confirmed!"
        format.json { render json: { success: true } }
      else
        format.json { render json: { success: false } }
      end
    end
  end

  private

  def update_ticket_booking_status_params
    params.require(:itinerary).permit(:ticket_booking_status)
  end

  def itinerary_params
    params.require(:itinerary).permit(:start_date, :end_date, :interest, :number_of_pax, dietary_preferences: [])
  end

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
  end

  def travel_params
    params.require(:travel).permit(:mode, :itinerary_attraction_from_id, :itinerary_attraction_to_id)
  end
end