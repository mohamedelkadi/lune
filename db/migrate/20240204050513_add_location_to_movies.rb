class AddLocationToMovies < ActiveRecord::Migration[7.0]
  def change
    add_reference :movies, :location, null: false, foreign_key: true
  end
end
