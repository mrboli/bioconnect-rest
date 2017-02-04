Rails.application.routes.draw do
  #get 'api', to: 'api#index'

  #resources :timecards

  namespace :api do
    #TODO: List the api version in config and validate
    namespace :v1 do 
      resources :timecards
      resources :time_entries
    end
  end
end
