class MoviesController < ApplicationController
  def index
    @movies = Movie.by_title_or_director(params[:query])
    # only checks the duration if there is a duration in the params
    @movies = @movies.by_duration(params[:duration]) if params[:duration]
    # duration_selections gets the keys from the constant DURATION_RANGES 
    # => on the Movie class an dmap over it using the 
    # => movies.duration_ranges in /config/locales/en.yml
    @duration_selections = Movie::DURATION_RANGES.keys.map do |key|
      [I18n.t(key, scope: "movies.duration_ranges"), key]
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update_attributes(movie_params)
      redirect_to movies_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

  protected

  def movie_params
    params.require(:movie).permit(
      :title, :release_date, :director, :runtime_in_minutes, :poster_image_url, :poster_image,:description
      )
  end

  def search_params
    params.permit(:query, :duration)
  end
end
