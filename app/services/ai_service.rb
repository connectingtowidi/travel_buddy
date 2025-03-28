require "openai"
require "json"

class AiService
  EMBEDDINGS_MODEL = 'text-embedding-3-small'
  MODEL = 'gpt-4o-mini'

  def self.get_response_from_ai(response_format, messages)
    open_ai_response = client.chat(
      parameters: { model: MODEL, response_format:, messages: }
    )

    begin
      response_content = open_ai_response.dig("choices", 0, "message", "content");
      JSON.parse(response_content)
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse OpenAI response: #{e.message}")
      {}
    end
  end

  def self.client
    @client ||= OpenAI::Client.new
  end

  def self.generate_embeddings(input)
    response = client.embeddings(
      parameters: {
        model: EMBEDDINGS_MODEL,
        input: input
      }
    )

    response && response['data'] ? response['data'].first['embedding'] : []
  end
end
