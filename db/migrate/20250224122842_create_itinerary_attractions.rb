class CreateItineraryAttractions < ActiveRecord::Migration[7.1]
  def change
    create_table :itinerary_attractions do |t|
      t.references :itinerary, null: false, foreign_key: true
      t.references :attraction, null: false, foreign_key: true
      t.integer :order
      t.timestamptz :starting_time

      t.timestamps
    end
  end
end
