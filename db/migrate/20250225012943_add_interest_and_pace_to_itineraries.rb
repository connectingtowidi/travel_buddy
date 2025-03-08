class AddInterestAndPaceToItineraries < ActiveRecord::Migration[7.1]
  def change
    add_column :itineraries, :interest, :string
    add_column :itineraries, :pace, :string
  end
end
