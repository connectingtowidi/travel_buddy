class AddDayToItineraryAttractions < ActiveRecord::Migration[7.1]
  def change
    add_column :itinerary_attractions, :day, :integer
  end
end
