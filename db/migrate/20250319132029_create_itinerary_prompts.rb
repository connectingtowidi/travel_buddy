class CreateItineraryPrompts < ActiveRecord::Migration[6.1]
  def change
    create_table :itinerary_prompts do |t|
      t.references :itinerary, null: false, foreign_key: true
      t.text :prompt
      t.text :response
      
      t.timestamps
    end
  end
end
