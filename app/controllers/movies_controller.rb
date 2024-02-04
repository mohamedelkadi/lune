# app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def index
    @movies = if params[:search].present?
                Movie.joins(:actors)
                     .where('actors.name LIKE ?', "%#{params[:search]}%")
                     .includes(:reviews, :location, :director)
                     .distinct
              else
                Movie.all
              end

    @movies = @movies.left_joins(:reviews)
                     .group('movies.id')
                     .order(Arel.sql('AVG(reviews.stars) DESC NULLS LAST'))
                     .includes(:reviews, :location, :director)
  end
end
