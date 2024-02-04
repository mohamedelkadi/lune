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
                .order(Arel.sql("average_rating #{sort_order} NULLS LAST"))
                .includes(:reviews, :locations, :director)
  end

  private
  def sort_order
    @sort_order ||= %w[asc desc].include?(params[:sort_order]) ? params[:sort_order] : 'desc'
  end
end
