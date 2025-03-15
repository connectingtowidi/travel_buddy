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

itinerary_2 = Itinerary.create!(
    name: 'Green Escape Journey: Chilling in nature',
    duration: 1,
    user: user1,
    interest: 'nature',
    number_of_pax: 1,
    start_date: Date.new(2025, 4, 16),
    end_date: Date.new(2025, 4, 18)
)

itinerary_3 = Itinerary.create!(
    name: 'Tiny Feet, Big Adventures: Singapore with Kids',
    duration: 2,
    user: user2,
    interest: 'kids-friendly',
    number_of_pax: 3,
    start_date: Date.new(2025, 4, 10),
    end_date: Date.new(2025, 4, 13)
)

itinerary_4 = Itinerary.create!(
    name: 'Flavours of the Lion City: A Culinary Journey',
    duration: 1,
    user: user3,
    interest: 'food',
    number_of_pax: 2,
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
    duration: 2,
    price: 20.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 294265,
    rating: 4.5,
    num_reviews: 7391,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.5-MCID-5.png",
    trip_types: ["couples", "solo", "business", "friends", "families"],
    weekday_text: ["Monday: 10:00 AM - 7:00 PM", "Tuesday: 10:00 AM - 7:00 PM", "Wednesday: 10:00 AM - 7:00 PM", "Thursday: 10:00 AM - 7:00 PM", "Friday: 10:00 AM - 7:00 PM", "Saturday: 10:00 AM - 7:00 PM", "Sunday: 10:00 AM - 7:00 PM"],
    latitude: 1.290270,
    longitude: 103.851959,
    email: "info@nationalgallery.sg",
    phone: "+65 6271 7000",
    website: "http://www.nationalgallery.sg"
)

attraction_history_2 = Attraction.create!(
    name: 'National Museum of Singapore',
    address_string: '93 Stamford Road',
    description: 'The National Museum of Singapore is a national museum of Singapore. It is the oldest museum in Singapore and the first national museum in Southeast Asia. The museum is located in the Civic District.',
    # opening_hour: '10:00',
    # closing_hour: '18:30',
    duration: 2,
    price: 24.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 324650,
    rating: 4.5,
    num_reviews: 5829,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.5-MCID-5.png",
    trip_types: ["couples", "solo", "business", "friends", "families"],
    weekday_text: ["Monday: 10:00 AM - 6:30 PM", "Tuesday: 10:00 AM - 6:30 PM", "Wednesday: 10:00 AM - 6:30 PM", "Thursday: 10:00 AM - 6:30 PM", "Friday: 10:00 AM - 6:30 PM", "Saturday: 10:00 AM - 6:30 PM", "Sunday: 10:00 AM - 6:30 PM"],
    latitude: 1.296667,
    longitude: 103.848611,
    email: "nhb_nm_corpcomms@nhb.gov.sg",
    phone: "+65 6332 3659",
    website: "http://www.nationalmuseum.sg"
)

attraction_history_3 = Attraction.create!(
    name: 'Fort Siloso',
    address_string: '20 Bukom Hill',
    description: 'Fort Siloso is a fort located in Singapore. It is a historical fort that was built in the 19th century.',
    # opening_hour: '10:00',
    # closing_hour: '17:00',
    duration: 3,
    price: 0.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 311897,
    rating: 4.0,
    num_reviews: 2341,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.0-MCID-5.png",
    trip_types: ["couples", "friends", "families"],
    weekday_text: ["Monday: 10:00 AM - 6:00 PM", "Tuesday: 10:00 AM - 6:00 PM", "Wednesday: 10:00 AM - 6:00 PM", "Thursday: 10:00 AM - 6:00 PM", "Friday: 10:00 AM - 6:00 PM", "Saturday: 10:00 AM - 6:00 PM", "Sunday: 10:00 AM - 6:00 PM"],
    latitude: 1.258056,
    longitude: 103.809722,
    email: "fortsiloso@sentosa.com.sg",
    phone: "+65 6736 8672",
    website: "http://www.fortsiloso.com"
)

attraction_history_4 = Attraction.create!(
    name: 'Peranakan Museum',
    address_string: '26 Armenian St',
    description: 'The Peranakan Museum is a museum in Singapore that showcases the Peranakan culture. It is a museum that is dedicated to the Peranakan culture.',
    # opening_hour: '10:00',
    # closing_hour: '19:00',
    duration: 1,
    price: 18.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 324908,
    rating: 4.5,
    num_reviews: 1523,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.5-MCID-5.png",
    trip_types: ["couples", "solo", "friends", "families"],
    weekday_text: ["Monday: Closed", "Tuesday: 10:00 AM - 7:00 PM", "Wednesday: 10:00 AM - 7:00 PM", "Thursday: 10:00 AM - 7:00 PM", "Friday: 10:00 AM - 7:00 PM", "Saturday: 10:00 AM - 7:00 PM", "Sunday: 10:00 AM - 7:00 PM"],
    latitude: 1.294444,
    longitude: 103.849722,
    email: "nhb_pm_enquiry@nhb.gov.sg",
    phone: "+65 6332 7591",
    website: "http://www.peranakanmuseum.sg"
)

attraction_history_5 = Attraction.create!(
    name: 'Asian Civilisations Museum',
    address_string: '1 Empress Place',
    description: 'The Asian Civilisations Museum is a museum in Singapore that showcases the Asian civilisations. It is a museum that is dedicated to the Asian civilisations.',
    # opening_hour: '10:00',
    # closing_hour: '19:00',
    duration: 2,
    price: 15.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 324751,
    rating: 4.5,
    num_reviews: 3876,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.5-MCID-5.png",
    trip_types: ["couples", "solo", "friends", "families"],
    weekday_text: ["Monday: 10:00 AM - 7:00 PM", "Tuesday: 10:00 AM - 7:00 PM", "Wednesday: 10:00 AM - 7:00 PM", "Thursday: 10:00 AM - 7:00 PM", "Friday: 10:00 AM - 9:00 PM", "Saturday: 10:00 AM - 7:00 PM", "Sunday: 10:00 AM - 7:00 PM"],
    latitude: 1.287222,
    longitude: 103.851389,
    email: "nhb_acm_enquiry@nhb.gov.sg",
    phone: "+65 6332 7798",
    website: "http://www.acm.org.sg"
)

attraction_nature_1 = Attraction.create!(
    name: 'Flower Dome at Garden by the Bay',
    address_string: '18 Marina Gardens Dr',
    description: 'The Flower Dome at Garden by the Bay is a greenhouse in Singapore that showcases the flowers. It is a greenhouse that is dedicated to the flowers.',
    # opening_hour: '09:00',
    # closing_hour: '21:00',
    duration: 2,
    price: 20.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 2331323,
    rating: 4.5,
    num_reviews: 14562,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.5-MCID-5.png",
    trip_types: ["couples", "friends", "families"],
    weekday_text: ["Monday: 9:00 AM - 9:00 PM", "Tuesday: 9:00 AM - 9:00 PM", "Wednesday: 9:00 AM - 9:00 PM", "Thursday: 9:00 AM - 9:00 PM", "Friday: 9:00 AM - 9:00 PM", "Saturday: 9:00 AM - 9:00 PM", "Sunday: 9:00 AM - 9:00 PM"],
    latitude: 1.284722,
    longitude: 103.865833,
    email: "feedback@gardensbythebay.com.sg",
    phone: "+65 6420 6848",
    website: "http://www.gardensbythebay.com.sg"
)

attraction_nature_2 = Attraction.create!(
    name: 'Cloud Forest at Gardens by the Bay',
    address_string: '18 Marina Gardens Dr',
    description: 'The Cloud Forest at Gardens by the Bay is a greenhouse in Singapore that showcases the clouds. It is a greenhouse that is dedicated to the clouds.',
    # opening_hour: '09:00',
    # closing_hour: '20:00',
    duration: 4,
    price: 25.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 2331324,
    rating: 4.5,
    num_reviews: 14562,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.5-MCID-5.png",
    trip_types: ["couples", "friends", "families"],
    weekday_text: ["Monday: 9:00 AM - 9:00 PM", "Tuesday: 9:00 AM - 9:00 PM", "Wednesday: 9:00 AM - 9:00 PM", "Thursday: 9:00 AM - 9:00 PM", "Friday: 9:00 AM - 9:00 PM", "Saturday: 9:00 AM - 9:00 PM", "Sunday: 9:00 AM - 9:00 PM"],
    latitude: 1.284167,
    longitude: 103.866111,
    email: "feedback@gardensbythebay.com.sg",
    phone: "+65 6420 6848",
    website: "http://www.gardensbythebay.com.sg"
)

attraction_nature_3 = Attraction.create!(
    name: 'Singapore Botanic Gardens',
    address_string: '1 Cluny Rd',
    description: 'The Singapore Botanic Gardens is a botanical garden in Singapore. It is a botanical garden that is dedicated to the plants.',
    # opening_hour: '05:00',
    # closing_hour: '23:00',
    duration: 2,
    price: 0.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 324542,
    rating: 4.5,
    num_reviews: 19876,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.5-MCID-5.png",
    trip_types: ["couples", "solo", "friends", "families"],
    weekday_text: ["Monday: 5:00 AM - 12:00 AM", "Tuesday: 5:00 AM - 12:00 AM", "Wednesday: 5:00 AM - 12:00 AM", "Thursday: 5:00 AM - 12:00 AM", "Friday: 5:00 AM - 12:00 AM", "Saturday: 5:00 AM - 12:00 AM", "Sunday: 5:00 AM - 12:00 AM"],
    latitude: 1.315556,
    longitude: 103.815556,
    email: "nparks_sbg_visitor_services@nparks.gov.sg",
    phone: "+65 6471 7138",
    website: "http://www.sbg.org.sg"
)

attraction_nature_4 = Attraction.create!(
    name: 'MacRitchie Reservoir',
    address_string: '262A Upper Thomson Rd',
    description: 'The MacRitchie Reservoir is a reservoir in Singapore. It is a reservoir that is dedicated to the water.',
    # opening_hour: '07:00',
    # closing_hour: '19:00',
    duration: 2,
    price: 0.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 324761,
    rating: 4.5,
    num_reviews: 1234,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.5-MCID-5.png",
    trip_types: ["couples", "solo", "friends"],
    weekday_text: ["Monday: 7:00 AM - 7:00 PM", "Tuesday: 7:00 AM - 7:00 PM", "Wednesday: 7:00 AM - 7:00 PM", "Thursday: 7:00 AM - 7:00 PM", "Friday: 7:00 AM - 7:00 PM", "Saturday: 7:00 AM - 7:00 PM", "Sunday: 7:00 AM - 7:00 PM"],
    latitude: 1.340556,
    longitude: 103.833889,
    email: "nparks_public_affairs@nparks.gov.sg",
    phone: "+65 1800 471 7300",
    website: "http://www.nparks.gov.sg"
)

attraction_nature_5 = Attraction.create!(
    name: 'Fort Canning Park',
    address_string: 'Fort Canning Park',
    description: 'The Fort Canning Park is a park in Singapore. It is a park that is dedicated to the history.',
    # opening_hour: '07:00',
    # closing_hour: '19:00',
    duration: 2,
    price: 0.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 324757,
    rating: 4.0,
    num_reviews: 2345,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.0-MCID-5.png",
    trip_types: ["couples", "solo", "friends", "families"],
    weekday_text: ["Monday: 24 hours", "Tuesday: 24 hours", "Wednesday: 24 hours", "Thursday: 24 hours", "Friday: 24 hours", "Saturday: 24 hours", "Sunday: 24 hours"],
    latitude: 1.295278,
    longitude: 103.845833,
    email: "nparks_fort_canning_park@nparks.gov.sg",
    phone: "+65 1800 471 7300",
    website: "http://www.nparks.gov.sg"
)

attraction_kids_1 = Attraction.create!(
    name: 'ArtScience Museum',
    address_string: '6 Bayfront Avenue',
    description: 'The ArtScience Museum is a museum in Singapore. It is a museum that is dedicated to the art and science.',
    # opening_hour: '08:00',
    # closing_hour: '20:00',
    duration: 2,
    price: 35.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 2331322,
    rating: 4.5,
    num_reviews: 7654,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.5-MCID-5.png",
    trip_types: ["couples", "friends", "families"],
    weekday_text: ["Monday: 10:00 AM - 7:00 PM", "Tuesday: 10:00 AM - 7:00 PM", "Wednesday: 10:00 AM - 7:00 PM", "Thursday: 10:00 AM - 7:00 PM", "Friday: 10:00 AM - 7:00 PM", "Saturday: 10:00 AM - 7:00 PM", "Sunday: 10:00 AM - 7:00 PM"],
    latitude: 1.286111,
    longitude: 103.859444,
    email: "museumenquiries@marinabaysands.com",
    phone: "+65 6688 8888",
    website: "http://www.marinabaysands.com/museum.html"
)

attraction_kids_2 = Attraction.create!(
    name: 'Singapore Flyer',
    address_string: '30 Raffles Ave',
    description: 'The Singapore Flyer is a ferris wheel in Singapore. It is a ferris wheel that is dedicated to the city.',
    # opening_hour: '08:00',
    # closing_hour: '20:00',
    duration: 1,
    price: 33.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 324761,
    rating: 4.0,
    num_reviews: 8765,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.0-MCID-5.png",
    trip_types: ["couples", "friends", "families"],
    weekday_text: ["Monday: 8:30 AM - 10:30 PM", "Tuesday: 8:30 AM - 10:30 PM", "Wednesday: 8:30 AM - 10:30 PM", "Thursday: 8:30 AM - 10:30 PM", "Friday: 8:30 AM - 10:30 PM", "Saturday: 8:30 AM - 10:30 PM", "Sunday: 8:30 AM - 10:30 PM"],
    latitude: 1.289444,
    longitude: 103.863333,
    email: "customer_service@singaporeflyer.com",
    phone: "+65 6333 3311",
    website: "http://www.singaporeflyer.com"
)

attraction_kids_3 = Attraction.create!(
    name: 'Universal Studios Singapore',
    address_string: '8 Sentosa Gateway',
    description: 'The Universal Studios Singapore is a theme park in Singapore. It is a theme park that is dedicated to the movies.',
    # opening_hour: '09:00',
    # closing_hour: '18:00',
    duration: 3,
    price: 100.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 2331321,
    rating: 4.5,
    num_reviews: 19876,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.5-MCID-5.png",
    trip_types: ["couples", "friends", "families"],
    weekday_text: ["Monday: 10:00 AM - 7:00 PM", "Tuesday: 10:00 AM - 7:00 PM", "Wednesday: 10:00 AM - 7:00 PM", "Thursday: 10:00 AM - 7:00 PM", "Friday: 10:00 AM - 7:00 PM", "Saturday: 10:00 AM - 7:00 PM", "Sunday: 10:00 AM - 7:00 PM"],
    latitude: 1.254167,
    longitude: 103.823889,
    email: "enquiries@rwsentosa.com",
    phone: "+65 6577 8888",
    website: "http://www.rwsentosa.com"
)

attraction_kids_4 = Attraction.create!(
    name: 'Underwater World Singapore',
    address_string: '8 Sentosa Gateway',
    description: 'The Underwater World Singapore is a theme park in Singapore. It is a theme park that is dedicated to the movies.',
    # opening_hour: '09:00',
    # closing_hour: '18:00',
    duration: 2,
    price: 30.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 324752,
    rating: 4.0,
    num_reviews: 5432,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.0-MCID-5.png",
    trip_types: ["couples", "friends", "families"],
    weekday_text: ["Monday: 10:00 AM - 7:00 PM", "Tuesday: 10:00 AM - 7:00 PM", "Wednesday: 10:00 AM - 7:00 PM", "Thursday: 10:00 AM - 7:00 PM", "Friday: 10:00 AM - 7:00 PM", "Saturday: 10:00 AM - 7:00 PM", "Sunday: 10:00 AM - 7:00 PM"],
    latitude: 1.258333,
    longitude: 103.811944,
    email: "enquiry@underwaterworld.com.sg",
    phone: "+65 6577 8888",
    website: "http://www.underwaterworld.com.sg"
)

attraction_kids_5 = Attraction.create!(
    name: 'Singapore Zoo',
    address_string: '80 Mandai Lake Road',
    description: 'The Singapore Zoo is a zoo in Singapore. It is a zoo that is dedicated to the animals.',
    # opening_hour: '09:00',
    # closing_hour: '18:00',
    duration: 3,
    price: 30.00,
    reviews: [],
    tripadvisor_photos: [],
    location_id: 324543,
    rating: 4.5,
    num_reviews: 23456,
    rating_image_url: "https://www.tripadvisor.com/img/cdsi/img2/ratings/traveler/4.5-MCID-5.png",
    trip_types: ["couples", "friends", "families"],
    weekday_text: ["Monday: 8:30 AM - 6:00 PM", "Tuesday: 8:30 AM - 6:00 PM", "Wednesday: 8:30 AM - 6:00 PM", "Thursday: 8:30 AM - 6:00 PM", "Friday: 8:30 AM - 6:00 PM", "Saturday: 8:30 AM - 6:00 PM", "Sunday: 8:30 AM - 6:00 PM"],
    latitude: 1.404444,
    longitude: 103.793056,
    email: "info.zoo@wrs.com.sg",
    phone: "+65 6269 3411",
    website: "http://www.wrs.com.sg/en/singapore-zoo"
)

puts "Creating itineraries Attractions..."

# itinerary_attraction_(itinerary_id)_(day)_(order)
itinerary_attraction_111 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attraction_history_1,
    day: 1,
    duration: 1,
    starting_time: DateTime.new(2025, 3, 26, 10, 0, 0, "+08:00")
)

itinerary_attraction_112 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attraction_history_2,
    day: 1,
    duration: 2,
    starting_time: DateTime.new(2025, 3, 26, 14, 0, 0, "+08:00")
)

itinerary_attraction_113 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attraction_history_3,
    day: 1,
    duration: 3,
    starting_time: DateTime.new(2025, 3, 26, 17, 0, 0, "+08:00")
)

itinerary_attraction_121 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attraction_history_4,
    day: 2,
    duration: 1,
    starting_time: DateTime.new(2025, 3, 27, 8, 0, 0, "+08:00")
)

itinerary_attraction_122 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attraction_history_5,
    day: 2,
    duration: 2,
    starting_time: DateTime.new(2025, 3, 27, 14, 0, 0, "+08:00")
)

itinerary_attraction_123 = ItineraryAttraction.create!(
    itinerary: itinerary_1,
    attraction: attraction_history_2,
    day: 2,
    duration: 2,
    starting_time: DateTime.new(2025, 3, 27, 18, 0, 0, "+08:00")
)

itinerary_attraction_211 = ItineraryAttraction.create!(
    itinerary: itinerary_2,
    attraction: attraction_nature_1,
    day: 1,
    duration: 1,
    starting_time: DateTime.new(2025, 4, 17, 9, 0, 0, "+08:00")
)

itinerary_attraction_212 = ItineraryAttraction.create!(
    itinerary: itinerary_2,
    attraction: attraction_nature_2,
    day: 1,
    duration: 2,
    starting_time: DateTime.new(2025, 4, 17, 16, 0, 0, "+08:00")
)

itinerary_attraction_311 = ItineraryAttraction.create!(
    itinerary: itinerary_3,
    attraction: attraction_kids_1,
    day: 1,
    duration: 1,
    starting_time: DateTime.new(2025, 4, 11, 8, 0, 0, "+08:00")
)

itinerary_attraction_312 = ItineraryAttraction.create!(
    itinerary: itinerary_3,
    attraction: attraction_kids_2,
    day: 1,
    duration: 2,
    starting_time: DateTime.new(2025, 4, 11, 13, 0, 0, "+08:00")
)

itinerary_attraction_313 = ItineraryAttraction.create!(
    itinerary: itinerary_3,
    attraction: attraction_kids_3,
    day: 1,
    duration: 3,
    starting_time: DateTime.new(2025, 4, 11, 17, 0, 0, "+08:00")
)

itinerary_attraction_321 = ItineraryAttraction.create!(
    itinerary: itinerary_3,
    attraction: attraction_kids_4,
    day: 2,
    duration: 1,
    starting_time: DateTime.new(2025, 4, 12, 9, 0, 0, "+08:00")
)

itinerary_attraction_322 = ItineraryAttraction.create!(
    itinerary: itinerary_3,
    attraction: attraction_kids_5,
    day: 2,
    duration: 2,
    starting_time: DateTime.new(2025, 4, 12, 16, 0, 0, "+08:00")
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

travel_211_212 = Travel.create!(
    itinerary_attraction_from: itinerary_attraction_211,
    itinerary_attraction_to: itinerary_attraction_212,
    mode: 'DRIVE',
    duration: 15
)

travel_311_312 = Travel.create!(
    itinerary_attraction_from: itinerary_attraction_311,
    itinerary_attraction_to: itinerary_attraction_312,
    mode: 'BICYCLE',
    duration: 20
)

travel_312_313 = Travel.create!(
    itinerary_attraction_from: itinerary_attraction_312,
    itinerary_attraction_to: itinerary_attraction_313,
    mode: 'TRANSIT',
    duration: 25
)

travel_321_322 = Travel.create!(
    itinerary_attraction_from: itinerary_attraction_321,
    itinerary_attraction_to: itinerary_attraction_322,
    mode: 'DRIVE',
    duration: 40
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
