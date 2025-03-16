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
    name: '(Summarised) Stories of the Straits: Singapore in Two Days',
    duration: 2,
    user: user1,
    interest: 'history',
    number_of_pax: 1,
    start_date: Date.new(2025, 3, 25),
    end_date: Date.new(2025, 3, 28)
)

puts "Creating attractions..."

Rake::Task['gov_attractions:update'].invoke
Rake::Task['gov_attractions:clean'].invoke
# CAUTION: The following makes ~300 API requests to TripAdvisor API
# Rake::Task['gov_attractions:merge'].invoke

puts "Creating itineraries Attractions..."

attractions = Attraction.first(5)

# itinerary_attraction_(itinerary_id)_(day)_(order)
itinerary_attraction_111 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attractions[0],
    day: 1,
    duration: 1,
    starting_time: DateTime.new(2025, 3, 26, 10, 0, 0, "+08:00")
)

itinerary_attraction_112 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attractions[1],
    day: 1,
    duration: 2,
    starting_time: DateTime.new(2025, 3, 26, 14, 0, 0, "+08:00")
)

itinerary_attraction_113 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attractions[2],
    day: 1,
    duration: 3,
    starting_time: DateTime.new(2025, 3, 26, 17, 0, 0, "+08:00")
)

itinerary_attraction_121 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attractions[3],
    day: 2,
    duration: 1,
    starting_time: DateTime.new(2025, 3, 27, 8, 0, 0, "+08:00")
)

itinerary_attraction_122 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attractions[4],
    day: 2,
    duration: 2,
    starting_time: DateTime.new(2025, 3, 27, 14, 0, 0, "+08:00")
)

itinerary_attraction_123 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attractions[2],
    day: 2,
    duration: 2,
    starting_time: DateTime.new(2025, 3, 27, 18, 0, 0, "+08:00")
)

puts "Creating travel..."

travel_111_112 = Travel.create!(
  itinerary_attraction_from: itinerary_attraction_111,
  itinerary_attraction_to: itinerary_attraction_112,
  mode: 'TRANSIT',
  duration: 20  
)

travel_112_113 = Travel.create!(
  itinerary_attraction_from: itinerary_attraction_112,
  itinerary_attraction_to: itinerary_attraction_113,
  mode: 'DRIVE',
  duration: 40 
)

travel_121_122 = Travel.create!(
    itinerary_attraction_from: itinerary_attraction_121,
    itinerary_attraction_to: itinerary_attraction_122,
    mode: 'WALK',
    duration: 35
)

travel_122_123 = Travel.create!(
  itinerary_attraction_from: itinerary_attraction_122,
  itinerary_attraction_to: itinerary_attraction_123,
  mode: 'TRANSIT',
  duration: 30  
)

puts "Creating payments..."

payment_1 = Payment.create!(
    itinerary: itinerary_1,
    payment_status: false
)

puts "Finished! Created #{User.count} users."
puts "Finished! Created #{Itinerary.count} itineraries."
puts "Finished! Created #{Attraction.count} attractions."
puts "Finished! Created #{ItineraryAttraction.count} itinerary attractions."
puts "Finished! Created #{Travel.count} travels."
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
