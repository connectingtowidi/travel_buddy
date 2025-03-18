class ChangeItinerariesDietaryPreferencesToArray < ActiveRecord::Migration[7.1]
  def change
    add_column :itineraries, :dietary_preferences, :string, array: true, default: []
  end
end
