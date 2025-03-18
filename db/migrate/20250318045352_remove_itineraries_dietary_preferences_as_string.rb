class RemoveItinerariesDietaryPreferencesAsString < ActiveRecord::Migration[7.1]
  def change
    remove_column :itineraries, :dietary_preferences, :string
  end
end
