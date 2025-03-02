class RenameAddressToAddressStringInAttractions < ActiveRecord::Migration[7.1]
  def change
    rename_column :attractions, :address, :address_string
  end
end
