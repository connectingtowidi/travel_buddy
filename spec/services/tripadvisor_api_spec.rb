require 'rails_helper'

RSpec.describe TripadvisorService do
  describe '.get_top_attractions' do
    let(:mock_search_response) do
      {
        "data" => [
          {
            "location_id" => "123",
            "name" => "Gardens by the Bay"
          },
          {
            "location_id" => "456",
            "name" => "Marina Bay Sands"
          },
          {
            "location_id" => "789",
            "name" => "Singapore Zoo"
          }
        ]
      }
    end

    let(:mock_details_response) do
      {
        "address_obj" => "18 Marina Gardens Drive",
        "description" => "Beautiful garden in Singapore",
        "duration" => "2-3 hours"
      }
    end

    let(:mock_photos_response) do
      {
        "data" => [
          { "images" => { "large" => { "url" => "photo1.jpg" } } },
          { "images" => { "large" => { "url" => "photo2.jpg" } } }
        ]
      }
    end

    let(:mock_reviews_response) do
      {
        "data" => [
          { "title" => "Amazing!", "text" => "Great place to visit" },
          { "title" => "Beautiful", "text" => "Loved it" }
        ]
      }
    end

    before do
      # Stub the initial search request
      allow(described_class).to receive(:make_request)
        .with(URI.parse(/.*\/location\/search.*/))
        .and_return(mock_search_response)

      # Stub details requests
      allow(described_class).to receive(:make_request)
        .with(URI.parse(/.*\/location\/\d+\/details.*/))
        .and_return(mock_details_response)

      # Stub photos requests
      allow(described_class).to receive(:make_request)
        .with(URI.parse(/.*\/location\/\d+\/photos.*/))
        .and_return(mock_photos_response)

      # Stub reviews requests
      allow(described_class).to receive(:make_request)
        .with(URI.parse(/.*\/location\/\d+\/reviews.*/))
        .and_return(mock_reviews_response)
    end

    it 'returns formatted attractions data' do
      result = described_class.get_top_attractions
      
      expect(result.length).to eq(3)
      expect(result.first).to include(
        name: "Gardens by the Bay",
        address: "18 Marina Gardens Drive",
        description: "Beautiful garden in Singapore",
        duration: "2-3 hours"
      )
      expect(result.first[:photos]).to be_an(Array)
      expect(result.first[:reviews]).to be_an(Array)
    end

    context 'when API calls fail' do
      before do
        allow(described_class).to receive(:make_request)
          .with(URI.parse(/.*\/location\/search.*/))
          .and_return({})
      end

      it 'returns an empty array' do
        expect(described_class.get_top_attractions).to eq([])
      end
    end
  end

  describe '.make_request' do
    let(:mock_url) { URI("#{TripadvisorService::BASE_URL}/location/search") }
    let(:mock_response) { instance_double(Net::HTTPSuccess) }

    context 'when request is successful' do
      before do
        allow(Net::HTTP).to receive(:new).and_return(double(
          use_ssl: true,
          read_timeout: 10,
          open_timeout: 10,
          request: mock_response
        ))
        allow(mock_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
        allow(mock_response).to receive(:body).and_return('{"data": "test"}')
      end

      it 'returns parsed JSON response' do
        expect(described_class.send(:make_request, mock_url)).to eq({ "data" => "test" })
      end
    end

    context 'when request fails' do
      before do
        allow(Net::HTTP).to receive(:new).and_raise(StandardError.new("Connection failed"))
      end

      it 'returns empty hash and logs error' do
        expect(Rails.logger).to receive(:error).with(/Tripadvisor API Error: Connection failed/)
        expect(described_class.send(:make_request, mock_url)).to eq({})
      end
    end
  end
end 