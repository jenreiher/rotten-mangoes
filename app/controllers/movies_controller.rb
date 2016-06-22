class MoviesController < ApplicationController
  def index
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
    params.permit(:title, :director, :duration)
  end
end
