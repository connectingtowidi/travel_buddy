class ItineraryAttraction < ApplicationRecord
  belongs_to :itinerary
  belongs_to :attraction
  has_one :journey, dependent: :destroy

  validates :day, presence: true, numericality: { greater_than: 0 }
  validates :order, presence: true, numericality: { greater_than: 0 }
  validates :starting_time, presence: true
end
