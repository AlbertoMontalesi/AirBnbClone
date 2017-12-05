class ReservationsController < ApplicationController
  ## only logged in user can book
  before_action :authenticate_user!

  def create
    ## the route to reservations is room/room_id thats why we can access the room id here
    room = Room.find(params[:room_id])

    if current_user == room.user
      flash[:alert] = "You can't book your own property"
    else
      start_date = Date.parse(reservation_params[:start_date])
      end_date = Date.parse(reservation_params[:end_date])
      ## we need to add 1 or the number of days will not include the starting date
      days = (end_date - start_date).to_i + 1 

      ## we say reservations because a user can have multiple 
      @reservation = current_user.reservations.build(reservation_params)
      ## we pass the room down here 
      @reservation.room = room
      @reservation.price = room.price
      @reservation.total = room.price * days
      @reservation.save

      flash[:notice] = "Booked Successfully"
    end
    
    redirect_to room
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date)
  end

end