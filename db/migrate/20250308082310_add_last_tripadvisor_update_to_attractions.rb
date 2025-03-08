class AddLastTripadvisorUpdateToAttractions < ActiveRecord::Migration[7.1]
  def change
    add_column :attractions, :last_tripadvisor_update, :datetime
  end
end
