require 'stripe'
Stripe.api_key = ENV["STRIPE_API_KEY"]

unless ENV["STRIPE_API_KEY"].present?
  Rails.logger.warn "WARNING: Missing STRIPE_API_KEY environment variable"
end 