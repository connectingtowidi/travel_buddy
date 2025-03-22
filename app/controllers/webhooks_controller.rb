# class WebhooksController < ApplicationController
#   skip_before_action :verify_authenticity_token
  
#   def stripe
#     payload = request.body.read
#     sig_header = request.env['HTTP_STRIPE_SIGNATURE']
#     endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']
    
#     begin
#       event = Stripe::Webhook.construct_event(
#         payload, sig_header, endpoint_secret
#       )
#     rescue JSON::ParserError => e
#       return head :bad_request
#     rescue Stripe::SignatureVerificationError => e
#       return head :bad_request
#     end
    
#     # Handle the event
#     case event.type
#     when 'checkout.session.completed'
#       session = event.data.object
      
#       # Update your database to record the payment
#       attraction_id = session.metadata.attraction_id
#       # Create order, ticket, etc.
      
#     end
    
#     head :ok
#   end
# end 