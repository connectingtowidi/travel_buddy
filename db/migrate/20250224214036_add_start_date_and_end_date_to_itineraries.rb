class AddStartDateAndEndDateToItineraries < ActiveRecord::Migration[7.1]
  def change
    add_column :itineraries, :start_date, :date
    add_column :itineraries, :end_date, :date
  end
end
