class AddLabelsToAttraction < ActiveRecord::Migration[7.1]
  def change
    add_column :attractions, :labels, :string, array: true, default: []
  end
end
