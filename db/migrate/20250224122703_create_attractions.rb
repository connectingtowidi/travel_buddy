class CreateAttractions < ActiveRecord::Migration[7.1]
  def change
    create_table "attractions", force: :cascade do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "day"
      t.string "name"
      t.string "address_string"
      t.text "description"
      t.integer "duration"
      t.string "phone"
      t.jsonb "reviews", default: []
      t.jsonb "photos", default: []
    end
  end
end
