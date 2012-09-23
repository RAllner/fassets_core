Rails.application.routes.draw do
  devise_for :users

  resource :url

  root :to => "FassetsCore::Catalogs#index"
end
