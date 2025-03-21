class CreateRestaurantRecommendations < ActiveRecord::Migration[7.1]
  def change
    create_table :restaurant_recommendations do |t|
      t.string :name
      t.string :address
      t.float :rating          # Changed from string to float
      t.integer :user_ratings_total
      t.text :description
      t.json :types            # Changed from string to json (for multiple types)
      t.string :google_maps_uri
      t.references :itinerary_attraction, null: false, foreign_key: { to_table: :itinerary_attractions }

      t.timestamps
    end
  end
end
