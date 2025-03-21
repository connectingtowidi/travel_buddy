class CreateItineraries < ActiveRecord::Migration[7.1]
  def change
    create_table :itineraries do |t|
      t.string :name
      t.integer :duration
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
