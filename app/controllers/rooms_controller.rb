class RoomsController < ApplicationController

  ## use a before action so you dont have to write set room under all the actions. we dont want it for index new and create as we dont have a room during those actions
  before_action :set_room, except: [:index, :new, :create]

  ## we want the user to be logged in for all actions apart from the show one because it is public to all users, even not logged in
  before_action :authenticate_user!, except: [:show]


  before_action :is_authorised, only: [:listing, :pricing, :description, :photo_upload, :amenities, :location, :update]

  def index
    @rooms = current_user.rooms
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    ## we define the params below
    @room = current_user.rooms.build(room_params)
    if @room.save
      redirect_to listing_room_path(@room), notice: "Saved..."
    else
      flash[:alert] = "Something went wrong..."
      render :new
    end
  end

  def show
  end

  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
    @photos = @room.photos
  end

  def amenities
  end

  def location
  end

  def update
    new_params = room_params
    new_params = room_params.merge(active: true) if is_ready_room 
    if @room.update(new_params)
      flash[:notice] = "Saved..."
    else
      flash[:alert] = "Something went wrong..."
    end
    ## redirect back to the page where we came from
    redirect_back(fallback_location: request.referer)
  end

  private

  def set_room
    @room = Room.find(params[:id])    
  end

  def is_ready_room
    !@room.active && !@room.price.blank? && !@room.listing_name.blank? && !@room.photos.blank? && !@room.address.blank?
  end

  def room_params
    params.require(:room).permit(:home_type, :room_type, :accommodate, :bed_room, :bath_room, :listing_name, :summary, :address, :is_tv, :is_kitchen, :is_air, :is_heating, :is_internet, :price, :active)
  end

  def is_authorised
    redirect_to root_path, alert: "You don't have permission" unless current_user.id == @room.user.id 
  end
end
