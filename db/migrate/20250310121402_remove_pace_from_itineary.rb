class RemovePaceFromItineary < ActiveRecord::Migration[7.1]
  def change
    remove_column :itineraries, :pace, :string
  end
end
