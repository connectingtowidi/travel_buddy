class ItineraryPrompt < ApplicationRecord
  belongs_to :itinerary
  
  validates :prompt, presence: true
  
  default_scope { order(created_at: :asc) }
end
