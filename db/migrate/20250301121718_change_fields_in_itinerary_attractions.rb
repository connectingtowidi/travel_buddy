class ChangeFieldsInItineraryAttractions < ActiveRecord::Migration[7.1]
  def change
     # Remove existing columns
     remove_column :itinerary_attractions, :starting_time
     remove_column :itinerary_attractions, :order
     
     # Add new columns
     add_column :itinerary_attractions, :duration, :string
  end
end
