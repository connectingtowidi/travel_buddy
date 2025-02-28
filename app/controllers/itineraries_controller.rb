class ItinerariesController < ApplicationController
  before_action :set_itinerary, only: [:show]

  def index
    @itineraries = current_user.itineraries
  end

  def show  
    @itinerary = Itinerary.includes(itinerary_attractions: :attraction).find(params[:id])
    # Add some debugging
    puts "Itinerary: #{@itinerary.name}"
    puts "Number of attractions: #{@itinerary.itinerary_attractions.count}"
    puts "Attractions: #{@itinerary.itinerary_attractions.map { |ia| ia.attraction.name }}"
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
