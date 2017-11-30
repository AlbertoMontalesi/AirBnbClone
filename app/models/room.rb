class Room < ApplicationRecord
  belongs_to :user
  has_many :photos

  validates :home_type, presence: true
  validates :room_type, presence: true
  validates :accommodate, presence: true
  validates :bed_room, presence: true
  validates :bath_room, presence: true

  def cover_photo(size)
    if self.photos.length > 0
      ## if there is a photo display the first one as cover
      photos[0].image.url(size)
    else
      ## otherwise display the placeholder
      'blank.jpg'
    end
  end
end
