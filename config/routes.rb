Rails.application.routes.draw do
  namespace :api do
    #TODO: List the api version in config and validate
    namespace :v1 do 
      resources :timecards, only: [:index, :show, :create, :update, :destroy]
      resources :time_entries, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
