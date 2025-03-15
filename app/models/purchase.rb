class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :attraction
  
  validates :amount, presence: true
  validates :payment_intent_id, presence: true, uniqueness: true
end 