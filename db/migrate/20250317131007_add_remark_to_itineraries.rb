class AddRemarkToItineraries < ActiveRecord::Migration[7.1]
  def change
    add_column :itineraries, :remark, :string
  end
end
