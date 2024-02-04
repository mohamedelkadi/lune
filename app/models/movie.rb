class Movie < ApplicationRecord
  has_many :reviews
  has_many :movie_actors
  has_many :actors, through: :movie_actors
  has_many :movie_locations
  has_many :locations, through: :movie_locations
  belongs_to :director

  validates :title, presence: true
end
