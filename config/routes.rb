Rails.application.routes.draw do
  resources :catalogs do
    resources :facets do
      resources :labels do
        collection do
          put :sort
        end
      end
    end
    put :add_asset
  end

  resources :facets do
    collection do
      post :sort
    end
  end

  resources :classifications

  resources :users do
    resources :tray_positions do
      collection do
        put :replace
      end
    end
  end

  # assets
  resources :urls
  resources :file_assets do
    member do
      get :thumb
      get :preview
      get :original
    end
  end

  match 'file_assets/:id' => 'FileAssets#update'
  match 'urls/:id' => 'Urls#update'
  match 'asset/:id/preview' => 'Assets#preview'
  match 'asset/:id/edit' => 'Assets#edit'
  match 'asset/:id/classifications' => 'Assets#classifications'
  match 'catalog_box' => 'Catalogs#catalog_box'
  match 'box_content' => 'Catalogs#box_content'
  match 'box_facet' => 'Catalogs#box_facet'
  match 'edit_box/:id' => 'Assets#edit_box'
  match 'new_remote_file' => 'FileAssets#new_remote_file'
  match 'get_wiki_imgs' => 'FileAssets#get_wiki_imgs'
  match 'search_wiki_imgs' => 'FileAssets#search_wiki_imgs'
  match 'add_wiki_img' => 'FileAssets#add_wiki_image'
  match 'add_asset_box' => 'Assets#add_asset_box'

  root :to => "Catalogs#index"
end
