class Movie < ApplicationRecord
  has_many :reviews
  has_many :movie_actors
  has_many :actors, through: :movie_actors
  belongs_to :location
  belongs_to :director


  validates :title, presence: true
end
