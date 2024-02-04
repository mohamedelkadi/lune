# lib/tasks/import.rake
require 'smarter_csv'

namespace :import do
  desc "Import Movies and Reviews from CSV files"
  task movies_and_reviews: :environment do
    country_hash = {}
    location_hash = {}
    director_hash = {}
    actor_hash = {}
    movie_hash = {}

    # Import Movies
    SmarterCSV.process('lib/seeds/movies.csv', { key_mapping: { movie: :title, filming_location: :location }, remove_unmapped_keys: false }) do |chunk|
      chunk.each do |row|
        puts "Importing #{row}"
        row = row.with_indifferent_access
        country = country_hash[row[:country]] ||= Country.find_or_create_by!(name: row[:country])
        location = location_hash[row[:location]] ||= Location.find_or_create_by!(name: row[:location], country: country)
        director = director_hash[row[:director]] ||= Director.find_or_create_by!(name: row[:director])

        movie = Movie.find_or_create_by!(
          title: row[:title],
          description: row[:description],
          year: row[:year],
          location: location,
          director: director
        )

        actor = Actor.find_or_create_by!(name: row[:actor].strip)
        MovieActor.find_or_create_by!(movie: movie, actor: actor)

        movie_hash[row[:movie]] = movie
      end
    end

    # Import Reviews
    SmarterCSV.process('lib/seeds/reviews.csv', { key_mapping: { movie: :movie_title }, remove_unmapped_keys: false }) do |chunk|
      chunk.each do |row|

        movie = movie_hash[row[:movie_title]] || Movie.find_by!(title: row[:movie_title])
        user = User.find_or_create_by!(name: row[:user])

        Review.find_or_create_by!(
          movie: movie,
          user: user,
          stars: row[:stars],
          review: row[:review]
        )
      end
    end

    puts "Import completed successfully."
  end
end
