class CreatePurchases < ActiveRecord::Migration[7.1]
  def change
    create_table :purchases do |t|
      t.references :user, null: false, foreign_key: true
      t.references :attraction, null: false, foreign_key: true
      t.decimal :amount
      t.string :payment_intent_id

      t.timestamps
    end
  end
end
