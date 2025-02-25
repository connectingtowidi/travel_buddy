class CreateJourneys < ActiveRecord::Migration[7.1]
  def change
    create_table :journeys do |t|
      t.references :itinerary_attraction, null: false, foreign_key: true
      t.string :mode

      t.timestamps
    end
  end
end
