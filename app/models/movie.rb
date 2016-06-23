class Movie < ActiveRecord::Base

  mount_uploader :poster_image, PosterImageUploader

  has_many :reviews

  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

  validates :poster_image,
    presence: true

  validates :release_date, 
    presence: true

  validate :release_date_is_in_the_past

  def review_average
    if reviews.size > 0
      reviews.sum(:rating_out_of_ten)/reviews.size
    else
      "-"
    end
  end

  def self.search(params)
    if params[:title]
      if params[:duration] == "1"
        @movies = Movie.where("title like ? AND director like ?",
          "%#{params[:title]}%", "%#{params[:director]}%")
      elsif params[:duration] == "2"
        @movies = Movie.where("title like ? AND director like ? AND runtime_in_minutes < ?", 
        "%#{params[:title]}%", "%#{params[:director]}%", 90)
      elsif params[:duration] == "3"
        @movies = Movie.where("title like ? AND director like ? AND runtime_in_minutes BETWEEN ? AND ?", 
        "%#{params[:title]}%", "%#{params[:director]}%", 90, 120)
      elsif params[:duration] == "4"
        @movies = Movie.where("title like ? AND director like ? AND runtime_in_minutes > ?", 
        "%#{params[:title]}%", "%#{params[:director]}%", 120)
      end
    else
      @movies = Movie.all
    end
  end

  private

  def release_date_is_in_the_past
    if release_date.present?
      errors.add(:release_date, "should be in the past") if release_date > Date.today
    end 
  end



end
