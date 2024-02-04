class MoviesController < ApplicationController
  def index
    base_query = if params[:search].present?
                   Movie.joins(:actors)
                        .where('actors.name LIKE ?', "%#{params[:search]}%")
                        .distinct
                 else
                   Movie.all
                 end

    @movies = base_query
                .left_joins(:reviews)
                .select('movies.*', 'AVG(reviews.stars) AS average_rating')
                .group('movies.id')
                .order(Arel.sql('average_rating DESC NULLS LAST'))
                .includes(:reviews, :location, :director)
  end
end
