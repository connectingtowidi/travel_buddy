# require 'stripe'
#
class StripeApi
#   def self.setup
#     if ENV["STRIPE_API_KEY"].blank?
#       Rails.logger.error "Missing STRIPE_API_KEY environment variable"
#       return false
#     end
#     Stripe.api_key = ENV["STRIPE_API_KEY"]
#     true
#   end
#
#   def self.create_payment_intent(attraction_id)
#     setup
#
#     begin
#       attraction = Attraction.find(attraction_id)
#       # Convert price to cents for Stripe
#       price_in_cents = (attraction.price * 100).to_i
#
#       Stripe::PaymentIntent.create({
#         amount: price_in_cents,
#         currency: 'sgd',
#         metadata: {
#           attraction_id: attraction.id,
#           attraction_name: attraction.name
#         }
#       })
#     rescue ActiveRecord::RecordNotFound => e
#       Rails.logger.error "Attraction not found: #{attraction_id}"
#       raise e
#     rescue => e
#       Rails.logger.error "Error creating payment intent: #{e.message}"
#       raise e
#     end
#   end
#
#   def self.test_stripe_api(attraction_id)
#     attraction = Attraction.find(attraction_id)
#     payment_intent = StripeApi.create_payment_intent(attraction.id)
#     return {
#       success: true,
#       payment_intent_id: payment_intent.id,
#       amount: payment_intent.amount,
#       client_secret: payment_intent.client_secret
#     }
#
#   rescue => e
#     render json: { success: false, error: e.message }, status: :unprocessable_entity
#   end
#
#   def self.create_checkout_session(attraction_id, success_url, cancel_url, current_user = nil)
#     setup
#
#     begin
#       attraction = Attraction.find(attraction_id)
#       price_in_cents = (attraction.price * 100).to_i
#
#       # Format the success URL correctly for Stripe parameter expansion
#       success_url_with_params = "#{success_url}?payment_intent={CHECKOUT_SESSION_PAYMENT_INTENT}"
#
#       checkout_params = {
#         payment_method_types: ['card'],
#         line_items: [{
#           price_data: {
#             currency: 'sgd',
#             product_data: {
#               name: attraction.name,
#               description: attraction.description&.truncate(100),
#               images: attraction.tripadvisor_photos.present? ? [attraction.tripadvisor_photos.first] : []
#             },
#             unit_amount: price_in_cents,
#           },
#           quantity: 1,
#         }],
#         mode: 'payment',
#         success_url: success_url_with_params,
#         cancel_url: cancel_url,
#         metadata: {
#           attraction_id: attraction.id
#         }
#       }
#
#       # Add user_id to metadata if a user is provided
#       if current_user.present?
#         checkout_params[:metadata][:user_id] = current_user.id
#       end
#
#       Stripe::Checkout::Session.create(checkout_params)
#     rescue => e
#       Rails.logger.error "Error creating checkout session: #{e.message}"
#       raise e
#     end
#   end
end
