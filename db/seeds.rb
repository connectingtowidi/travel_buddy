# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Travel.destroy_all
Payment.destroy_all
ItineraryAttraction.destroy_all
Attraction.destroy_all
Itinerary.destroy_all
User.destroy_all


puts "Creating users..."

user1 = User.create!(
  email: 'user1@mail.com',
  password: 'user1pw'
)

user2 = User.create!(
  email: 'user2@mail.com',
  password: 'user2pw'
)

user3 = User.create!(
  email: 'user3@mail.com',
  password: 'user3pw'
)

puts "Creating itineraries..."
itinerary_1 = Itinerary.create!(
    name: '(Summarised) Stories of the Straits: Singapore in a Day',
    duration: 2,
    user: user1,
    interest: 'history',
    pace: 'fast',
    start_date: Date.new(2025, 3, 25),
    end_date: Date.new(2025, 3, 28)
)

itinerary_2 = Itinerary.create!(
    name: 'Green Escape Journey: Chilling in nature',
    duration: 1,
    user: user1,
    interest: 'nature',
    pace: 'slow',
    start_date: Date.new(2025, 4, 16),
    end_date: Date.new(2025, 4, 18)
)

itinerary_3 = Itinerary.create!(
    name: 'Tiny Feet, Big Adventures: Singapore with Kids',
    duration: 2,
    user: user2,
    interest: 'kids-friendly',
    pace: 'slow',
    start_date: Date.new(2025, 4, 10),
    end_date: Date.new(2025, 4, 13)   
)

itinerary_4 = Itinerary.create!(
    name: 'Flavours of the Lion City: A Culinary Journey',
    duration: 1,
    user: user3,
    interest: 'food',
    pace: 'slow',
    start_date: Date.new(2025, 3, 18),
    end_date: Date.new(2025, 3, 20)   
)

puts "Creating attractions..."

attraction_history_1 = Attraction.create!(
    name: 'National Gallery Singapore',
    address_string: '1 St Andrew\'s Road', 
    description: 'The National Gallery Singapore is a visual arts institution which oversees the largest public collection of modern art in Singapore and Southeast Asia. Situated in the Downtown Core of Singapore, the museum occupies two national monuments: the former Supreme Court Building and City Hall.',
    # opening_hour: '10:00',
    # closing_hour: '19:00', 
    # duration: 2,
    price: 20.00,
    reviews: [],
    photos: []
)

attraction_history_2 = Attraction.create!(
    name: 'National Museum of Singapore',
    address_string: '93 Stamford Road', 
    description: 'The National Museum of Singapore is a national museum of Singapore. It is the oldest museum in Singapore and the first national museum in Southeast Asia. The museum is located in the Civic District.',
    # opening_hour: '10:00',
    # closing_hour: '18:30',
    # duration: 2,
    price: 24.00,
    reviews: [],
    photos: []
)

attraction_history_3 = Attraction.create!(
    name: 'Fort Siloso',
    address_string: '20 Bukom Hill', 
    description: 'Fort Siloso is a fort located in Singapore. It is a historical fort that was built in the 19th century.',
    # opening_hour: '10:00',
    # closing_hour: '17:00',
    # duration: 3,
    price: 0.00,
    reviews: [],
    photos: []
)

attraction_history_4 = Attraction.create!(
    name: 'Peranakan Museum',
    address_string: '26 Armenian St', 
    description: 'The Peranakan Museum is a museum in Singapore that showcases the Peranakan culture. It is a museum that is dedicated to the Peranakan culture.',
    # opening_hour: '10:00',
    # closing_hour: '19:00',
    # duration: 1,
    price: 18.00,
    reviews: [],
    photos: []
)

attraction_history_5 = Attraction.create!(
    name: 'Asian Civilisations Museum',
    address_string: '1 Empress Place', 
    description: 'The Asian Civilisations Museum is a museum in Singapore that showcases the Asian civilisations. It is a museum that is dedicated to the Asian civilisations.',
    # opening_hour: '10:00',
    # closing_hour: '19:00',
    # duration: 2,
    price: 15.00,
    reviews: [],
    photos: []
)

attraction_nature_1 = Attraction.create!(
    name: 'Flower Dome at Garden by the Bay',
    address_string: '18 Marina Gardens Dr', 
    description: 'The Flower Dome at Garden by the Bay is a greenhouse in Singapore that showcases the flowers. It is a greenhouse that is dedicated to the flowers.',
    # opening_hour: '09:00',
    # closing_hour: '21:00',
    # duration: 2,
    price: 20.00,
    reviews: [],
    photos: []
)

attraction_nature_2 = Attraction.create!(
    name: 'Cloud Forest at Gardens by the Bay',
    address_string: '18 Marina Gardens Dr', 
    description: 'The Cloud Forest at Gardens by the Bay is a greenhouse in Singapore that showcases the clouds. It is a greenhouse that is dedicated to the clouds.',
    # opening_hour: '09:00',
    # closing_hour: '20:00',
    # duration: 4,
    price: 25.00,
    reviews: [],
    photos: []
)

attraction_nature_3 = Attraction.create!(
    name: 'Singapore Botanic Gardens',
    address_string: '1 Cluny Rd', 
    description: 'The Singapore Botanic Gardens is a botanical garden in Singapore. It is a botanical garden that is dedicated to the plants.',
    # opening_hour: '05:00',
    # closing_hour: '23:00',
    # duration: 2,
    price: 0.00,
    reviews: [],
    photos: []
)   

attraction_nature_4 = Attraction.create!(
    name: 'MacRitchie Reservoir',
    address_string: '262A Upper Thomson Rd', 
    description: 'The MacRitchie Reservoir is a reservoir in Singapore. It is a reservoir that is dedicated to the water.',
    # opening_hour: '07:00',
    # closing_hour: '19:00',
    # duration: 2,
    price: 0.00,
    reviews: [],
    photos: []
)

attraction_nature_5 = Attraction.create!(
    name: 'Fort Canning Park',
    address_string: 'Fort Canning Park', 
    description: 'The Fort Canning Park is a park in Singapore. It is a park that is dedicated to the history.',
    # opening_hour: '07:00',
    # closing_hour: '19:00',
    # duration: 2,
    price: 0.00,
    reviews: [],
    photos: []
)

attraction_kids_1 = Attraction.create!(
    name: 'ArtScience Museum',
    address_string: '6 Bayfront Avenue', 
    description: 'The ArtScience Museum is a museum in Singapore. It is a museum that is dedicated to the art and science.',
    # opening_hour: '08:00',
    # closing_hour: '20:00',
    # duration: 2,
    price: 35.00,
    reviews: [],
    photos: []
)

attraction_kids_2 = Attraction.create!(
    name: 'Singapore Flyer',
    address_string: '30 Raffles Ave', 
    description: 'The Singapore Flyer is a ferris wheel in Singapore. It is a ferris wheel that is dedicated to the city.',
    # opening_hour: '08:00',
    # closing_hour: '20:00',
    # duration: 1,
    price: 33.00,
    reviews: [],
    photos: []
)

attraction_kids_3 = Attraction.create!(
    name: 'Universal Studios Singapore',
    address_string: '8 Sentosa Gateway', 
    description: 'The Universal Studios Singapore is a theme park in Singapore. It is a theme park that is dedicated to the movies.',
    # opening_hour: '09:00',
    # closing_hour: '18:00',
    # duration: 3,
    price: 100.00,
    reviews: [],
    photos: []
)

attraction_kids_4 = Attraction.create!(
    name: 'Underwater World Singapore',
    address_string: '8 Sentosa Gateway', 
    description: 'The Underwater World Singapore is a theme park in Singapore. It is a theme park that is dedicated to the movies.',
    # opening_hour: '09:00',
    # closing_hour: '18:00',
    # duration: 2,
    price: 30.00,
    reviews: [],
    photos: []
)

attraction_kids_5 = Attraction.create!(
    name: 'Singapore Zoo',
    address_string: '80 Mandai Lake Road', 
    description: 'The Singapore Zoo is a zoo in Singapore. It is a zoo that is dedicated to the animals.',
    # opening_hour: '09:00',
    # closing_hour: '18:00',
    # duration: 3,
    price: 30.00,
    reviews: [],
    photos: []
)

puts "Creating itineraries Attractions..."

# itinerary_attraction_(itinerary_id)_(day)_(order)
itinerary_attraction_111 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attraction_history_1,
    day: 1,
    duration: 1
)

itinerary_attraction_112 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attraction_history_2,
    day: 1,
    duration: 2
    
)

itinerary_attraction_113 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attraction_history_3,
    day: 1,
    duration: 3
)

itinerary_attraction_121 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attraction_history_4,
    day: 2,
    duration: 2
)

itinerary_attraction_122 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attraction_history_5,
    day: 2,
    duration: 2
)

itinerary_attraction_123 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attraction_history_2,
    day: 2,
    duration: 2
)

itinerary_attraction_211 = ItineraryAttraction.create!(
    itinerary: itinerary_2,
    attraction: attraction_nature_1,
    day: 1,
    duration: 1
)

itinerary_attraction_212 = ItineraryAttraction.create!(
    itinerary: itinerary_2,
    attraction: attraction_nature_2,
    day: 1,
    duration: 2
)

itinerary_attraction_311 = ItineraryAttraction.create!(
    itinerary: itinerary_3,
    attraction: attraction_kids_1,
    day: 1,
    duration: 1
)

itinerary_attraction_312 = ItineraryAttraction.create!(
    itinerary: itinerary_3,
    attraction: attraction_kids_2,
    day: 1,
    duration: 2
)

itinerary_attraction_313 = ItineraryAttraction.create!(
    itinerary: itinerary_3,
    attraction: attraction_kids_3,
    day: 1,
    duration: 3
)

itinerary_attraction_321 = ItineraryAttraction.create!(
    itinerary: itinerary_3,
    attraction: attraction_kids_4,
    day: 2,
    duration: 1
)

itinerary_attraction_322 = ItineraryAttraction.create!(
    itinerary: itinerary_3,
    attraction: attraction_kids_5,
    day: 2,
    duration: 2
)

# puts "Creating journeys..."

# journey_111 = Journey.create!(
#     itinerary_attraction: itinerary_attraction_111,
#     mode: 'bus'
# )

# journey_112 = Journey.create!(
#     itinerary_attraction: itinerary_attraction_112,
#     mode: 'taxi'
# )

# journey_121 = Journey.create!(
#     itinerary_attraction: itinerary_attraction_121,
#     mode: 'walk'
# )

# journey_122 = Journey.create!(
#     itinerary_attraction: itinerary_attraction_122,
#     mode: 'bus'
# )

# journey_211 = Journey.create!(
#     itinerary_attraction: itinerary_attraction_211,   
#     mode: 'taxi'
# )

# journey_311 = Journey.create!(
#     itinerary_attraction: itinerary_attraction_311,
#     mode: 'bus'
# )

# journey_312 = Journey.create!(
#     itinerary_attraction: itinerary_attraction_312,
#     mode: 'taxi'
# )   

# journey_321 = Journey.create!(
#     itinerary_attraction: itinerary_attraction_321,
#     mode: 'bus'
# )

puts "Creating travel..."

travel_111_112 = Travel.create!(
  itinerary_attraction_from: itinerary_attraction_111,
  itinerary_attraction_to: itinerary_attraction_112,
  mode: 'bus'
)

travel_121_122 = Travel.create!(
    itinerary_attraction_from: itinerary_attraction_121,
    itinerary_attraction_to: itinerary_attraction_122,
    mode: 'walk'
)

travel_211_311 = Travel.create!(
    itinerary_attraction_from: itinerary_attraction_211,   
    itinerary_attraction_to: itinerary_attraction_311,
    mode: 'taxi'
)


puts "Creating payments..."

payment_1 = Payment.create!(
    itinerary: itinerary_1,
    payment_status: false
)

payment_2 = Payment.create!(
    itinerary: itinerary_2,
    payment_status: true
)

payment_3 = Payment.create!(
    itinerary: itinerary_3,
    payment_status: false
)

payment_4 = Payment.create!(
    itinerary: itinerary_4,
    payment_status: false
)

puts "Finished! Created #{User.count} users."
puts "Finished! Created #{Itinerary.count} itineraries."
puts "Finished! Created #{Attraction.count} attractions."
puts "Finished! Created #{ItineraryAttraction.count} itinerary attractions."
# puts "Finished! Created #{Journey.count} journeys."
puts "Finished! Created #{Payment.count} payments."

# Attach an image if you have one
# attraction = Attraction.create!(
#     name: 'Garden by the bay',
#     address_string: '18 Marina Gardens Dr', 
#     description: 'flower dome',
#     opening_hour: '08:00',
#     closing_hour: '16:00',
#     reviews: [],
#     photos: []
# )
# attraction.image.attach(io: File.open('path/to/image.jpg'), filename: 'garden.jpg')

# Note (Widi): I have not attached the image to the attraction because I do not have any image to attach. We can put later.
