class GuestReviewsController < ApplicationController
  def create
    ##  step 1: check if the reservation exist (room_id, host_id, host_id)
    @reservation = Reservation.where(
      id: guest_review_params[:reservation_id],
      room_id: guest_review_params[:room_id],
    ).first

    ## here to access the host_id we need to first walk backwards and grab the room of which this is the reservation and grab the user of that room
    if !@reservation.nil? && @reservation.room.user.id == guest_review_params[:host_id].to_i
      ## step 2: check if the current host already review the guest in this reservation
      @has_reviewed = GuestReview.where(
        reservation_id: @reservation.id,
        host_id: guest_review_params[:host_id]
      ).first
      ## if it is nil means that the user never reviewed the place before so he can continue
      if @has_reviewed.nil?
        ## create a review and redirect back to the current page
        @guest_review = current_user.guest_reviews.create(guest_review_params)
        flash[:success] = 'Review created...'
      else
        ## the user already reviewed
        flash[:alert] = 'You already reviewed this reservation'
      end
    else
      flash[:alert] = 'Not found this reservation'
    end

    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @guest_review = Review.find(params[:id])
    @guest_review.destroy
    redirect_back(fallback_location: request.referer, notice: 'Removed...')
  end

  private

  def guest_review_params
    ## we dont need to specify the host id  because we already have it, it's the id of the current user
    params.require(:guest_review).permit(:comment, :star, :room_id, :reservation_id, :host_id)
  end
end
