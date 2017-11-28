class PhotosController < ApplicationController
  
  def create
    @room = Room.find(params[:room_id])

    if params[:images]
      params[:images].each do |img|
        @room.photos.create(image: img)
      end
      @photos = @room.photos
      redirect_back(fallback_location: request.referer, notice: 'Saved...')
    end
  end

  def destroy 
    @photo = Photo.find(params[:id])
    room = @photo.room

    @photo.destroy
    @photos = Photo.where(room_id: room.id)

    ## rails will know to look in destroy.js.erb
    respond_to :js
  end
end
