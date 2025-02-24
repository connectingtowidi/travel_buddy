class Travel < ApplicationRecord
  belongs_to :itinerary_attraction_from
  belongs_to :itinerary_attraction_to
end
