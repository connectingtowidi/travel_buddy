class Attraction < ApplicationRecord
  has_many :itinerary_attractions
  has_many :itineraries, through: :itinerary_attractions

  has_neighbors :embedding
  after_create :set_embedding

  validates :name, presence: true

  def stale?
    last_tripadvisor_update.nil? || last_tripadvisor_update < 2.weeks.ago
  end

  def self.all_trip_types
      result = pluck(:labels).flatten.uniq.compact
    # Return default list if result is empty
      if result.empty?
        return ['Kids-focused', 'Culture', 'Food', 'Nature', 'Shopping']
      end
      
      result
  end

  def hero_image_url
    hero_image = tripadvisor_photos.first

    return nil if !hero_image
    
    if !hero_image.start_with?('http://') && !hero_image.start_with?('https://')
      "http://#{hero_image}"
    else
      hero_image
    end
  end

  private

  def set_embedding
    client = OpenAI::Client.new
    response = client.embeddings(
      parameters: {
        model: 'text-embedding-3-small',
        input: "Attraction: #{name}. Description: #{description} Trip Types: #{labels}"
      }
    )
    embedding = response['data'][0]['embedding']
    update(embedding: embedding)
  end

end
