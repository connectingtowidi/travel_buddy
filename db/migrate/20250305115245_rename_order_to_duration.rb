class RenameOrderToDuration < ActiveRecord::Migration[7.1]
  def change
    rename_column :itinerary_attractions, :order, :duration
  end
end
