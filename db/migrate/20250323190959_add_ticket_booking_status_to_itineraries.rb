class AddTicketBookingStatusToItineraries < ActiveRecord::Migration[7.1]
  def change
    add_column :itineraries, :ticket_booking_status, :string, default: "pending"
  end
end
