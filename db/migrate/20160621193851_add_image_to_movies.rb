class AddImageToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :poster_image, :string
  end
end
