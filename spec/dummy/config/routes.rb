Rails.application.routes.draw do
  devise_for :users

  resources :urls

  root :to => "FassetsCore::Catalogs#index"
end
