class Itinerary < ApplicationRecord
  belongs_to :user
  has_many :itinerary_attractions, dependent: :destroy
  has_many :attractions, through: :itinerary_attractions
  has_one :payment, dependent: :destroy

  validates :name, presence: true

  include PgSearch::Model
  pg_search_scope :search_by_name,
    against: [ :name ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }

  pg_search_scope :global_search,
  against: [ :name ],
  associated_against: {
    user: [ :email]
  },
  using: {
    tsearch: { prefix: true }
  }
end
