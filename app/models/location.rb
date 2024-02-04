class Location < ApplicationRecord
  has_many :movie_locations
  has_many :movies, through: :movie_locations
  # The relationship with Country remains unchanged
  belongs_to :country
end
