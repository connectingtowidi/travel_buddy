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
  email: 'mary@mail.com',
  password: '123456'
)

puts "Creating itineraries..."
itinerary1 = Itinerary.create!(
    name: '1 day trip to Garden by the Bay',
    duration: 1,
    user: user1
)

itinerary2 = Itinerary.create!(
    name: 'kids friendly trip',
    duration: 2,
    user: user1
)

puts "Creating itineraries Attractions..."
itineraryAttraction1 = ItineraryAttraction.create!(
    itinerary: itinerary2,
    attraction: Attraction.create!(
        name: 'Garden by the bay',
        address: '18 Marina Gardens Dr', 
        description: 'flower dome',
        opening_hour: '08:00',
        closing_hour: '16:00'
    ),
    order: 1,
    starting_time: '2025-02-25 10:10:10.555555-05:00'
)

itineraryAttraction2 = ItineraryAttraction.create!(
    itinerary: itinerary1,
    attraction: Attraction.create!(
        name: 'Marina Bay Sands',
        address: '10 Bayfront Avenue',
        description: 'Iconic hotel and casino', 
        opening_hour: '10:00',
        closing_hour: '22:00'
    ),
    order: 2,
    starting_time: '2025-02-25 10:15:10.555555-05:00'
)

puts "Creating payments..."
payment = Payment.create!(
    payment_status: false,
    itinerary: itinerary1
)

travel = Travel.create!(
    itinerary_attraction_from: itineraryAttraction1,
    itinerary_attraction_to: itineraryAttraction2,
    mode: 'bus'
)

# Attach an image if you have one
attraction = Attraction.create!(
    name: 'Garden by the bay',
    address: '18 Marina Gardens Dr', 
    description: 'flower dome',
    opening_hour: '08:00',
    closing_hour: '16:00'
)
attraction.image.attach(io: File.open('path/to/image.jpg'), filename: 'garden.jpg')
