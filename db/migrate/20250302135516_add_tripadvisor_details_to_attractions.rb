class AddTripadvisorDetailsToAttractions < ActiveRecord::Migration[7.1]
  def change
    add_column :attractions, :location_id, :integer
    add_column :attractions, :rating, :decimal, precision: 3, scale: 1
    add_column :attractions, :num_reviews, :integer
    add_column :attractions, :rating_image_url, :string
    add_column :attractions, :trip_types, :jsonb, default: []
    add_column :attractions, :weekday_text, :jsonb, default: []
    add_column :attractions, :latitude, :decimal, precision: 10, scale: 6
    add_column :attractions, :longitude, :decimal, precision: 10, scale: 6
    add_column :attractions, :email, :string
    add_column :attractions, :website, :string
  end
end