class AddEmbeddingToAttractions < ActiveRecord::Migration[7.1]
  def change
    add_column :attractions, :embedding, :vector, limit: 1536
  end
end
