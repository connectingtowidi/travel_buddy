class Travel < ApplicationRecord
    belongs_to :itinerary_attraction_from, class_name: 'ItineraryAttraction', foreign_key: 'itinerary_attraction_from_id'
    belongs_to :itinerary_attraction_to, class_name: 'ItineraryAttraction', foreign_key: 'itinerary_attraction_to_id'
end
