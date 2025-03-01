# app/controllers/attractions_controller.rb

class AttractionsController < ApplicationController
  def index
    attractions = TripadvisorApi.fetch_singapore_attractions
    render json: attractions
  end

  def show
    @attraction = Attraction.find(params[:id])
  end

  def generate
      # @tripadvisor_suggestions = TripadvisorApi.fetch_singapore_attractions
      @tripadvisor_suggestions = JSON.parse(File.read(Rails.root.join('app', 'controllers', 'temp_tripadvisor_results.json')))
      @tripadvisor_suggestions['attractions'].each do |attraction_data|
        attraction = Attraction.create!(
          name: attraction_data['name'],
          address_string: attraction_data['address']['address_string'],
          description: attraction_data['description'],
          reviews: attraction_data['reviews'].map { |r| {title: r['title'], text: r['text']} },
          photos: attraction_data['photos']
        )
      end
      # Attraction.destroy_all
      render json: {
        attractions: @tripadvisor_suggestions,
        status: 'success'
      }
    end
end
