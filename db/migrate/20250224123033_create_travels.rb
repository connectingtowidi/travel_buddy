class CreateTravels < ActiveRecord::Migration[7.1]
  def change
    create_table :travels do |t|
      t.references :itinerary_attraction_from, null: false, foreign_key: { to_table: :itinerary_attractions }
      t.references :itinerary_attraction_to, null: false, foreign_key: { to_table: :itinerary_attractions }
      t.string :mode

      t.timestamps
    end
  end
end
