class AddTripadvisorPhotosToAttractions < ActiveRecord::Migration[7.1]
  def change
    add_column :attractions, :tripadvisor_photos, :jsonb, default: []
  end
end
