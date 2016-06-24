class Movie < ActiveRecord::Base

  # the constant that holds the start and end times of the movie ranges
  DURATION_RANGES = {
    "blank" => [0, 8 * 60],
    "short" => [0, 90],
    "medium" => [90, 120],
    "long" => [120, 8 * 60]
  }.freeze

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

  def self.movie_duration
    DURATION_RANGES
  end

  def review_average
    if reviews.size > 0
      reviews.sum(:rating_out_of_ten)/reviews.size
    else
      "-"
    end
  end

  scope :by_title_or_director, ->(query_string) do
    where("title like :query OR director like :query", query: "%#{query_string}%")
  end

  scope :by_duration, -> (duration) do
    # checks if the duration from the query string is found in the 
    if DURATION_RANGES[duration]
      start, stop = DURATION_RANGES[duration]
      where("runtime_in_minutes > #{start} AND runtime_in_minutes < #{stop}")
    else
      # raises an exception if the duration is not in the constant
      raise ArgumentError, "Duration #{duration} is not a defined range"
    end
  end

  private

  def release_date_is_in_the_past
    if release_date.present?
      errors.add(:release_date, "should be in the past") if release_date > Date.today
    end 
  end

end
