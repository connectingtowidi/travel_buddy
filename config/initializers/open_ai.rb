OpenAI.configure do |config|
    config.access_token = ENV.fetch("OPENAPI_KEY")
end