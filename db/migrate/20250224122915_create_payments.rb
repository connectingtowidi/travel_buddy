class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.boolean :payment_status
      t.references :itinerary, null: false, foreign_key: true

      t.timestamps
    end
  end
end
