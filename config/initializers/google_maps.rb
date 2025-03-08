Google::Maps.configure do |config|
    config.authentication_mode = Google::Maps::Configuration::API_KEY
    config.api_key = ENV
end

Google::Maps.configure do |config|
    config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
end