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

    # Debug any cached data
    if current_user
      purchased_attractions = Purchase.where(user_id: current_user.id).pluck(:attraction_id)
      Rails.logger.debug "User #{current_user.id} has purchased attractions: #{purchased_attractions}"
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
      itinerary_params[:pax],
      itinerary_params[:dietary_preferences],
    )


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

      # travel = travel_map[itinerary_attraction.id]
      # if travel
      #   @travels << travel
      # else
      #   @travels << ["final stop"]
      # end


    end

    # @itinerary.itinerary_attractions.each do |itinerary_attraction|
    #   @markers['lat'] = itinerary_attraction.attraction.latitude.to_f,
    #   @markers['lng'] = itinerary_attraction.attraction.longitude.to_f,
    #   @markers['title'] = itinerary_attraction.attraction.name
    # end

  end

  def update_with_ai
    raise "TODO"

    user_prompt = params[:ai_prompt]
    locked_attractions_ids = params[:locked_attractions].to_s.split(',').map(&:to_i)
    locked_attractions = Attraction.where(id: locked_attractions_ids)

    TweakItineraryService.call(
      user_prompt:,
      locked_attractions:,
      itinerary: @itinerary
    )

    return render json: {
      locked_attractions: locked_attractions
    }
  end

  private

  def itinerary_params
    params.require(:itinerary).permit(:start_date, :end_date, :interest, :number_of_pax, dietary_preferences: [])
  end  

  def set_itinerary
    @itinerary = Itinerary.find(params[:id])
  end
end
