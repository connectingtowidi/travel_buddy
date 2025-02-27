class Itinerary < ApplicationRecord
  belongs_to :user
  has_many :itinerary_attractions, dependent: :destroy
  has_many :attractions, through: :itinerary_attractions
  has_one :payment, dependent: :destroy

  validates :name, presence: true

  def self.generate_from_preferences(user, duration, interest, pace = "normal")
    # Calculate end date based on duration
    start_date = Date.today
    end_date = start_date + duration.days
    
    # Create the itinerary
    itinerary = create!(
      name: "Your #{duration}-day #{interest.capitalize} Adventure in Singapore",
      duration: duration,
      user: user,
      interest: interest,
      pace: pace,
      start_date: start_date,
      end_date: end_date
    )

    # Get attractions based on interest
    attractions = Attraction.where(id: matching_attraction_ids(interest))
    
    # Create schedule for each day
    duration.times do |day|
      itinerary.schedule_day(day, attractions, pace)
    end

    # Create unpaid payment record
    Payment.create!(itinerary: itinerary, payment_status: false)

    itinerary
  end

  def schedule_day(day, attractions, pace)
    attractions_per_day = case pace
      when "fast" then 3
      when "moderate" then 2
      when "slow" then 1
      else 2  # default to moderate pace
    end
    day_attractions = attractions.sample(attractions_per_day)
    
    current_time = DateTime.new(
      start_date.year, 
      start_date.month, 
      start_date.day + day, 
      9, 0, 0, 
      "+08:00"
    )
    
    day_attractions.each_with_index do |attraction, index|
      ia = itinerary_attractions.create!(
        attraction: attraction,
        day: day + 1,
        order: index + 1,
        starting_time: current_time
      )

      # Add a journey
      Journey.create!(
        itinerary_attraction: ia,
        mode: ['bus', 'taxi', 'walk'].sample
      )

      # Update current_time for next attraction (add attraction duration plus 30 min travel time)
      current_time += (attraction.duration + 0.5).hours
    end
  end

  private

  def self.matching_attraction_ids(interest)
    case interest
    when 'history'
      Attraction.where("name LIKE ?", "%Museum%")
               .or(Attraction.where("name LIKE ?", "%Gallery%"))
               .or(Attraction.where("name LIKE ?", "%Fort%"))
               .pluck(:id)
    when 'nature'
      Attraction.where("name LIKE ?", "%Garden%")
               .or(Attraction.where("name LIKE ?", "%Park%"))
               .or(Attraction.where("name LIKE ?", "%Reservoir%"))
               .pluck(:id)
    when 'kids-friendly'
      Attraction.where("name LIKE ?", "%Zoo%")
               .or(Attraction.where("name LIKE ?", "%Universal%"))
               .or(Attraction.where("name LIKE ?", "%Museum%"))
               .or(Attraction.where("name LIKE ?", "%World%"))
               .pluck(:id)
    else
      Attraction.pluck(:id)
    end
  end
end
