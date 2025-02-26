class AddDurationToAttractions < ActiveRecord::Migration[7.1]
  def change
    add_column :attractions, :duration, :integer
  end
end
