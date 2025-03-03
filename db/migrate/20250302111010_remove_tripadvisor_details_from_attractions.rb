class RemoveTripadvisorDetailsFromAttractions < ActiveRecord::Migration[7.1]
  def change
    remove_column :attractions, :location_id, :string
    remove_column :attractions, :rating, :decimal, precision: 3, scale: 1
    remove_column :attractions, :num_reviews, :integer
    remove_column :attractions, :rating_image_url, :string
    remove_column :attractions, :trip_types, :jsonb, default: []
    remove_column :attractions, :weekday_text, :jsonb, default: []
    remove_column :attractions, :latitude, :decimal, precision: 10, scale: 6
    remove_column :attractions, :longitude, :decimal, precision: 10, scale: 6
    remove_column :attractions, :email, :string
    remove_column :attractions, :website, :string
  end
end
