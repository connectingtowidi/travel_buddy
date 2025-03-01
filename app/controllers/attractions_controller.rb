# app/controllers/attractions_controller.rb

class AttractionsController < ApplicationController
  def index
    attractions = TripadvisorApi.fetch_singapore_attractions
    render json: attractions
  end

  def show
    @attraction = Attraction.find(params[:id])
  end

end
