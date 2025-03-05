class ChangeTripTypesToStringInAttractions < ActiveRecord::Migration[7.1]
  def change
    change_column :attractions, :trip_types, :string, default: nil, using: 'trip_types::text'  \
  end
end
