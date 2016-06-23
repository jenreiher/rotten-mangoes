class Movie < ActiveRecord::Base

  scope :search_query, ->(params) { where("title like ? OR director like ?", "%#{params[:query]}%", "%#{params[:query]}%") }
  scope :duration_short, -> { where("runtime_in_minutes < 90") }
  scope :duration_medium, -> { where("runtime_in_minutes BETWEEN 90 AND 120") }
  scope :duration_long, -> { where("runtime_in_minutes > 120") }

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
    if params[:query]
      if params[:duration] == "1"
        @movies = Movie.search_query(params)
        #@movies = Movie.where("title like ? OR director like ?", "%#{params[:query]}%", "%#{params[:query]}%")
      elsif params[:duration] == "2"
        @movies = Movie.search_query(params).duration_short
      elsif params[:duration] == "3"
        @movies = Movie.search_query(params).duration_medium
      elsif params[:duration] == "4"
        @movies = Movie.search_query(params).duration_long
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
