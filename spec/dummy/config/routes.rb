Rails.application.routes.draw do
  devise_for :users

  resource :urls

  root :to => "FassetsCore::Catalogs#index"
end
