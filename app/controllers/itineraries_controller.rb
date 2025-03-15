class ItinerariesController < ApplicationController
  before_action :set_itinerary, only: [:show]

  def index
    @itineraries = current_user.itineraries
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

  def test_stripe_api
    @stripe_response = StripeApi.test_stripe_api(params[:attraction_id])
    render json: @stripe_response

  end
end
