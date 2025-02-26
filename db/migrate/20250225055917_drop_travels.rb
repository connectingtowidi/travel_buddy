class DropTravels < ActiveRecord::Migration[7.1]
  def change
    drop_table :travels
  end
end
