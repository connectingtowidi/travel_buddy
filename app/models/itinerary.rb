class Itinerary < ApplicationRecord
  belongs_to :user
  has_many :itinerary_attractions, dependent: :destroy
  has_many :attractions, through: :itinerary_attractions
  has_one :payment, dependent: :destroy

  validates :name, presence: true


end
