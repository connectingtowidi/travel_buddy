class AddPhoneToAttractions < ActiveRecord::Migration[7.1]
  def change
    add_column :attractions, :phone, :string
  end
end
