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
    pluck(:trip_types).uniq
  end

  private

  def set_embedding
    client = OpenAI::Client.new
    response = client.embeddings(
      parameters: {
        model: 'text-embedding-3-small',
        input: "Attraction: #{name}. Description: #{description} Trip Types: #{trip_types}"
      }
    )
    embedding = response['data'][0]['embedding']
    update(embedding: embedding)
  end

end
