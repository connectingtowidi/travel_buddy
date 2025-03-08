require 'stripe'

class StripeApi
  Stripe.api_key = ENV["STRIPE_API_KEY"]

  def self.setup
    if ENV["STRIPE_API_KEY"].blank?
      Rails.logger.error "Missing STRIPE_API_KEY environment variable"
      return false
    end
    true
  end

  # Add your Stripe-related methods here
  def self.create_payment_intent(amount, currency = 'sgd')
    setup
    
    begin
      Stripe::PaymentIntent.create({
        amount: amount,
        currency: currency,
      })
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe API Error: #{e.message}"
      nil
    end
  end

  # Add more Stripe methods as needed
end 