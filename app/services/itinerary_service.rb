# app/services/itinerary_service.rb
class ItineraryService
    def initialize(user, duration, interest, pace = "normal")
      @user = user
      @duration = duration
      @interest = interest
      @pace = pace
    end
  
    def generate
      start_date = Date.today
      end_date = start_date + @duration.days
      
      itinerary = Itinerary.create!(
        name: "Your #{@duration}-day #{@interest.capitalize} Adventure in Singapore",
        duration: @duration,
        user: @user,
        interest: @interest,
        pace: @pace,
        start_date: start_date,
        end_date: end_date
      )
  
      attractions = Attraction.where(id: matching_attraction_ids)
  
      @duration.times do |day|
        schedule_day(itinerary, day, attractions)
      end
  
      Payment.create!(itinerary: itinerary, payment_status: false)
  
      itinerary
    end
  
    private
  
    def matching_attraction_ids
      case @interest
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
  
    def schedule_day(itinerary, day, attractions)
        attractions_per_day = case @pace
                              when "fast" then 3
                              when "moderate" then 2
                              when "slow" then 1
                              else 2  # default to moderate pace
                              end
      
        day_attractions = attractions.sample(attractions_per_day)
        
        current_time = DateTime.new(
          itinerary.start_date.year,
          itinerary.start_date.month,
          itinerary.start_date.day + day,
          9, 0, 0,
          "+08:00"
        )
        
        previous_attraction = nil  # Start with no previous attraction
      
        day_attractions.each_with_index do |attraction, index|
          ia = itinerary.itinerary_attractions.create!(
            attraction: attraction,
            day: day + 1,
            order: index + 1,
            starting_time: current_time
          )
      
          # If there's a previous attraction, create a Travel object for the journey between them
          if previous_attraction
            Travel.create!(
              itinerary_attraction_from_id: previous_attraction.id,
              itinerary_attraction_to_id: ia.id,
              mode: ['bus', 'taxi', 'walk'].sample
            )
          end
      
          # Update current_time for next attraction (add attraction duration plus 30 min travel time)
          current_time += (attraction.duration + 0.5).hours
      
          # Set the current attraction as the previous attraction for the next loop iteration
          previous_attraction = ia
        end
      end
      
  end
  