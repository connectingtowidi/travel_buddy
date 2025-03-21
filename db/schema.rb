# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_03_19_231048) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "vector"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.decimal "price"
    t.integer "location_id"
    t.decimal "rating", precision: 3, scale: 1
    t.integer "num_reviews"
    t.string "rating_image_url"
    t.string "trip_types"
    t.jsonb "weekday_text", default: []
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "email"
    t.string "website"
    t.jsonb "tripadvisor_photos", default: []
    t.datetime "last_tripadvisor_update"
    t.vector "embedding", limit: 1536
    t.time "opening_hour"
    t.time "closing_hour"
    t.string "labels", default: [], array: true
  end

  create_table "itineraries", force: :cascade do |t|
    t.string "name"
    t.integer "duration"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_date"
    t.date "end_date"
    t.string "interest"
    t.integer "number_of_pax"
    t.string "remark"
    t.string "dietary_preferences", default: [], array: true
    t.index ["user_id"], name: "index_itineraries_on_user_id"
  end

  create_table "itinerary_attractions", force: :cascade do |t|
    t.bigint "itinerary_id", null: false
    t.bigint "attraction_id", null: false
    t.integer "duration"
    t.timestamptz "starting_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "day"
    t.index ["attraction_id"], name: "index_itinerary_attractions_on_attraction_id"
    t.index ["itinerary_id"], name: "index_itinerary_attractions_on_itinerary_id"
  end

  create_table "itinerary_prompts", force: :cascade do |t|
    t.bigint "itinerary_id", null: false
    t.text "prompt"
    t.text "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["itinerary_id"], name: "index_itinerary_prompts_on_itinerary_id"
  end

  create_table "payments", force: :cascade do |t|
    t.boolean "payment_status"
    t.bigint "itinerary_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["itinerary_id"], name: "index_payments_on_itinerary_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "attraction_id", null: false
    t.decimal "amount"
    t.string "payment_intent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attraction_id"], name: "index_purchases_on_attraction_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "restaurant_recommendations", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.float "rating"
    t.integer "user_ratings_total"
    t.text "description"
    t.json "types"
    t.string "google_maps_uri"
    t.bigint "itinerary_attraction_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["itinerary_attraction_id"], name: "index_restaurant_recommendations_on_itinerary_attraction_id"
  end

  create_table "solid_cable_messages", force: :cascade do |t|
    t.text "channel"
    t.text "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel"], name: "index_solid_cable_messages_on_channel"
    t.index ["created_at"], name: "index_solid_cable_messages_on_created_at"
  end

  create_table "travels", force: :cascade do |t|
    t.bigint "itinerary_attraction_from_id", null: false
    t.bigint "itinerary_attraction_to_id", null: false
    t.string "mode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duration"
    t.index ["itinerary_attraction_from_id"], name: "index_travels_on_itinerary_attraction_from_id"
    t.index ["itinerary_attraction_to_id"], name: "index_travels_on_itinerary_attraction_to_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "itineraries", "users"
  add_foreign_key "itinerary_attractions", "attractions"
  add_foreign_key "itinerary_attractions", "itineraries"
  add_foreign_key "itinerary_prompts", "itineraries"
  add_foreign_key "payments", "itineraries"
  add_foreign_key "purchases", "attractions"
  add_foreign_key "purchases", "users"
  add_foreign_key "restaurant_recommendations", "itinerary_attractions"
  add_foreign_key "travels", "itinerary_attractions", column: "itinerary_attraction_from_id"
  add_foreign_key "travels", "itinerary_attractions", column: "itinerary_attraction_to_id"
end
