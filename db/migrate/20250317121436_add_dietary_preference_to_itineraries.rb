class AddDietaryPreferenceToItineraries < ActiveRecord::Migration[7.1]
  def change
    add_column :itineraries, :dietary_preferences, :string
  end
end
