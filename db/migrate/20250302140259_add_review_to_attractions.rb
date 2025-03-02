class AddReviewToAttractions < ActiveRecord::Migration[7.1]
  def change
    add_column :attractions, :reviews, :jsonb, default: []
  end
end
