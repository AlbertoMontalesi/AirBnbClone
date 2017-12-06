class HostReviewsController < ApplicationController
  def create
    ##  step 1: check if the reservation exist (room_id, guest_id, host_id)
    @reservation = Reservation.where(
      id: host_review_params[:reservation_id],
      room_id: host_review_params[:room_id],
      user_id: host_review_params[:guest_id]
    ).first

    
    if !@reservation.nil?
      ## step 2: check if the current host already review the guest in this reservation
      @has_reviewed = HostReview.where(
        reservation_id: @reservation.id,
        guest_id: host_review_params[:guest_id]
      ).first
      ## if it is nil means that the user never reviewed the place before so he can continue
      if @has_reviewed.nil?
        ## create a review and redirect back to the current page
        @host_review = current_user.host_reviews.create(host_review_params)
        flash[:success] = 'Review created...'
      else
        ## the user already reviewed
        flash[:success] = 'You already reviewed this reservation'
      end
    else
      flash[:alert] = 'Not found this reservation'
    end

    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @host_review = Review.find(params[:id])
    @host_review.destroy
    redirect_back(fallback_location: request.referer, notice: 'Removed...')
  end

  private

  def host_review_params
    ## we dont need to specify the host id  because we already have it, it's the id of the current user
    params.require(:host).permit(:comment, :star, :room_id, :reservation_id, :guest_id)
  end
end
