# app/controllers/attractions_controller.rb
require_relative '../services/tripadvisor_api'

class AttractionsController < ApplicationController
    def index
      attractions = TripadvisorService.get_top_attractions
      render json: attractions
    end
  end
  
