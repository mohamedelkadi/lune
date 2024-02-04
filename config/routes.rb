Rails.application.routes.draw do
  resources :movies, only: [:index] # Creates the /movies route for the index action
  root to: 'movies#index' # Sets the root path to the movies index action
end
