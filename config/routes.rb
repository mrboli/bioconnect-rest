Rails.application.routes.draw do
  get 'api', to: 'api#index'

  namespace :api do
    #TODO: List the api version in config and validate
    namespace :v1 do 
      resources :TimeCard
    end
  end
end
