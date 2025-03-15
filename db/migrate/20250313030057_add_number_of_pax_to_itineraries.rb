class AddNumberOfPaxToItineraries < ActiveRecord::Migration[7.1]
  def change
    add_column :itineraries, :number_of_pax, :integer
  end
end
