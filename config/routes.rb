Rails.application.routes.draw do
  resources :catalogs do
    resources :facets do
      collection do
        post :sort
      end  
      resources :labels do
        collection do
          put :sort
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
  match 'asset/:id/edit' => 'Assets#edit'
  match 'asset/:id/classifications' => 'Assets#classifications'
  match 'catalog_box' => 'Catalogs#catalog_box'
  match 'box_content' => 'Catalogs#box_content'
  match 'box_facet' => 'Catalogs#box_facet'
  match 'edit_box/:id' => 'Assets#edit_box'
  match 'add_asset_box' => 'Assets#add_asset_box'
end
