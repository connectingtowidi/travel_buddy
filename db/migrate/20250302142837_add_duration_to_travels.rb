class AddDurationToTravels < ActiveRecord::Migration[7.1]
  def change
    add_column :travels, :duration, :integer
  end
end
