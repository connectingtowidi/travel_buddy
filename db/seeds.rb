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
RestaurantRecommendation.destroy_all
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
    remark: "This itinerary takes you through some of Singapore's most iconic and culturally rich attractions over two days. all the way, making it longer longeeeeeee",
    duration: 2,
    user: user1,
    interest: 'history',
    number_of_pax: 1,
    dietary_preferences: ['Vegetarian', 'Halal'],
    start_date: Date.new(2025, 3, 25),
    end_date: Date.new(2025, 3, 28)
)

puts "Creating attractions..."

Rake::Task['gov_attractions:update'].invoke
Rake::Task['gov_attractions:clean'].invoke
Rake::Task['gov_attractions:merge'].invoke

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


puts "Creating restaurant recommendations..."

# Example data for restaurant recommendations
restaurant_1 = RestaurantRecommendation.create!(
  name: 'Tasty Vegan Bistro',
  address: '123 Vegan Street, Singapore',
  rating: 4.5,
  user_ratings_total: 120,
  description: 'A cozy bistro offering delicious vegan dishes. Perfect for a plant-based meal.',
  types: ['vegan', 'healthy', 'organic'],
  google_maps_uri: 'https://maps.google.com/?q=Tasty+Vegan+Bistro',
  itinerary_attraction: itinerary_attraction_111  # You can associate this with an attraction
)

restaurant_2 = RestaurantRecommendation.create!(
  name: 'Halal Street Food',
  address: '456 Halal Lane, Singapore',
  rating: 4.0,
  user_ratings_total: 80,
  description: 'Serving up a variety of Halal-certified street food, great for casual dining.',
  types: ['halal', 'street food'],
  google_maps_uri: 'https://maps.google.com/?q=Halal+Street+Food',
  itinerary_attraction: itinerary_attraction_112
)

restaurant_3 = RestaurantRecommendation.create!(
  name: 'Seafood Paradise',
  address: '789 Ocean Drive, Singapore',
  rating: 4.7,
  user_ratings_total: 200,
  description: 'An upscale restaurant specializing in fresh seafood dishes.',
  types: ['seafood', 'fine dining'],
  google_maps_uri: 'https://maps.google.com/?q=Seafood+Paradise',
  itinerary_attraction: itinerary_attraction_113
)

restaurant_4 = RestaurantRecommendation.create!(
  name: 'Veggie Delight',
  address: '101 Green Ave, Singapore',
  rating: 4.2,
  user_ratings_total: 65,
  description: 'A vegetarian-friendly restaurant offering a wide selection of plant-based meals.',
  types: ['vegetarian', 'healthy'],
  google_maps_uri: 'https://maps.google.com/?q=Veggie+Delight',
  itinerary_attraction: itinerary_attraction_121
)

restaurant_5 = RestaurantRecommendation.create!(
  name: 'Gourmet Indian Cuisine',
  address: '102 Spice Rd, Singapore',
  rating: 4.6,
  user_ratings_total: 150,
  description: 'An authentic Indian restaurant known for its rich and flavorful dishes.',
  types: ['indian', 'halal'],
  google_maps_uri: 'https://maps.google.com/?q=Gourmet+Indian+Cuisine',
  itinerary_attraction: itinerary_attraction_122
)


puts "Finished! Created #{User.count} users."
puts "Finished! Created #{Itinerary.count} itineraries."
puts "Finished! Created #{Attraction.count} attractions."
puts "Finished! Created #{ItineraryAttraction.count} itinerary attractions."
puts "Finished! Created #{Travel.count} travels."
puts "Finished! Created #{Payment.count} payments."
puts "Finished! Created #{RestaurantRecommendation.count} restaurant recommendations."

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
