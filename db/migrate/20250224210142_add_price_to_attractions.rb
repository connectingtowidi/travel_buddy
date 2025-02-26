class AddPriceToAttractions < ActiveRecord::Migration[7.1]
  def change
    add_column :attractions, :price, :decimal
  end
end
