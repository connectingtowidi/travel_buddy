class PaymentsController < ApplicationController
  def create_checkout
    attraction_id = params[:attraction_id]
    
    # URLs for after payment (include your domain)
    success_url = attraction_payment_success_url(attraction_id)
    cancel_url = attraction_url(attraction_id)
    
    begin
      session = StripeApi.create_checkout_session(
        attraction_id,
        success_url,
        cancel_url,
        current_user
      )
      
      # Redirect to Stripe Checkout
      redirect_to session.url, allow_other_host: true
    rescue => e
      flash[:error] = "Could not initiate payment: #{e.message}"
      redirect_to attraction_path(attraction_id)
    end
  end
  
  def success
    @attraction = Attraction.find(params[:attraction_id])
    
    # Get the itinerary for redirection
    itinerary = @attraction.itinerary_attractions.first&.itinerary
    
    if params[:payment_intent].present?
      begin
        # First get the checkout session using the payment intent
        sessions = Stripe::Checkout::Session.list(
          payment_intent: params[:payment_intent],
          limit: 1
        )
        
        if sessions.data.any?
          session = sessions.data.first
          
          # Now we can verify if payment was successful
          if session.payment_status == 'paid'
            # Create a purchase record
            Purchase.create!(
              user_id: current_user.id,
              attraction_id: @attraction.id,
              amount: @attraction.price,
              payment_intent_id: params[:payment_intent]
            )
            
            # Set success message
            flash[:success] = "Payment successful! Your tickets have been purchased."
            
            # Redirect to the itinerary page
            redirect_to itinerary_path(itinerary) and return if itinerary
          end
        end
      rescue => e
        Rails.logger.error "Error in payment success: #{e.message}"
        flash[:error] = "There was an issue processing your payment. Please contact support."
      end
    end
    
    # If we reach here, either redirect to the itinerary or attractions page
    if itinerary
      redirect_to itinerary_path(itinerary)
    else
      redirect_to attractions_path
    end
  end
end 