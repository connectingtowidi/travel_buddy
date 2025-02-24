class CreateAttractions < ActiveRecord::Migration[7.1]
  def change
    create_table :attractions do |t|
      t.string :name
      t.string :address
      t.string :description
      t.time :opening_hour
      t.time :closing_hour
      t.timestamps
    end
  end
end
