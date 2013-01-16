Rails.application.routes.draw do
  resources :catalogs do
    resources :facets do
      collection do
        post :sort
      end
      resources :labels do
        collection do
          post :sort
        end
      end
    end
    put :add_asset
  end

  resources :classifications

  resources :users do
    resources :tray_positions do
      collection do
        put :replace
      end
    end
  end

  match 'asset/:id/preview' => 'Assets#preview'
  match 'asset/:id/classifications' => 'Assets#classifications'
  match 'catalog_box' => 'Catalogs#catalog_box'
  match 'box_content' => 'Catalogs#box_content'
  match 'box_facet' => 'Catalogs#box_facet'
  match 'assets/:asset_id/edit' => 'assets#edit', as: :edit_asset_path
  match 'assets/new' => 'assets#new', as: :new_asset_path
  match 'catalogs/new' => 'Catalogs#new', as: :new_catalog_path
  match 'facets/new' => 'facets#new', as: :new_facet_path
end
