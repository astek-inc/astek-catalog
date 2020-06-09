Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root 'admin/collections#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  namespace :admin do

    resources :product_imports, except: [:show, :delete], concerns: :paginatable

    resources :product_exports, only: [] do
      collection do
        get 'shopify_export_by_collection'
        get 'shopify_export_by_design'
        get 'shopify_export_by_sku'
        get 'shopify_export_all'
        get 'generate_shopify_collection_csv', defaults: { format: 'csv' }
        get 'generate_shopify_design_csv', defaults: { format: 'csv' }
        get 'generate_shopify_skus_csv', defaults: { format: 'csv' }
        # get 'generate_shopify_skus_csv', defaults: { format: 'csv' }
        get 'generate_shopify_all_csv', defaults: { format: 'csv' }
        get 'fedex_export_by_collection'
        get 'fedex_export_by_design'
        get 'fedex_export_by_sku'
        get 'fedex_export_all'
        get 'generate_fedex_collection_csv', defaults: { format: 'csv' }
        get 'generate_fedex_design_csv', defaults: { format: 'csv' }
        get 'generate_fedex_skus_csv', defaults: { format: 'csv' }
        # get 'generate_fedex_skus_csv', defaults: { format: 'csv' }
        get 'generate_fedex_all_csv', defaults: { format: 'csv' }
      end
    end

    # get 'order_limits_exports/generate_csv', to: 'order_limits_exports#generate_csv', as: 'order_limits_export_generate_csv', defaults: { format: 'csv' }
    resources :order_limits_exports, only: [] do
      collection do
        get 'export_by_collection'
        get 'export_by_design'
        # get 'export_by_sku'
        get 'generate_collection_csv', defaults: { format: 'csv' }
        get 'generate_design_csv', defaults: { format: 'csv' }
        # get 'generate_skus_csv', defaults: { format: 'csv' }
      end
    end

    resources :substrate_exports, only: :index #, defaults: { format: 'json' }

    resources :colors, except: [:show, :delete]

    resources :lead_times, except: [:show, :delete]

    resources :substrates, except: [:show, :delete], concerns: :paginatable do
      resources :substrate_images, only: [:index, :new, :create, :show, :destroy] do
        post :update_row_order, on: :collection
      end
    end

    resources :substrate_categories, except: [:show, :delete], concerns: :paginatable

    resources :backing_types, except: [:show, :delete], concerns: :paginatable do
      post :update_row_order, on: :collection
    end

    resources :users

    resources :websites, except: [:show, :delete]

    resources :styles, except: [:show, :delete]

    resources :vendors, except: [:show, :delete]

    resources :sale_units, except: [:show, :delete]

    resources :properties, except: [:show, :delete]

    resources :product_types, except: [:show, :delete], concerns: :paginatable

    resources :product_categories, except: [:show, :delete], concerns: :paginatable

    resources :keywords, concerns: :paginatable, except: [:show, :delete] do
      get :list, on: :collection, defaults: { format: 'json' }
    end

    resources :collections, concerns: :paginatable, except: [:show, :delete] do

      get :csv_export_search, on: :collection

      resources :designs, concerns: :paginatable, controller: :collection_designs do
        post :update_row_order, on: :collection
        get :custom_materials, on: :member
      end

      resources :subcollections, except: [:show, :delete]

      resources :design_aliases, except: [:show, :delete] do
        post :update_row_order, on: :collection
      end

    end

    resources :subcollection_types, except: [:show, :delete]

    # resources :designs, only: [:index], concerns: :paginatable do
    resources :designs, only: [], concerns: :paginatable do
      get :search, on: :collection
      get :csv_export_search, on: :collection
      get :design_alias_search, on: :collection

      # resources :design_styles #, only: :index

      resources :descriptions, controller: :design_descriptions

      resources :design_properties  do
        put :assign, on: :collection
        post :update_row_order, on: :collection
      end

      resources :variants, concerns: :paginatable do
        post :update_row_order, on: :collection
      end
    end

    resources :variants, concerns: :paginatable do
      resource :tearsheet, only: [:show], controller: :variant_tearsheets do
        post :generate, defaults: { format: 'pdf' }
      end

      resources :variant_swatch_images, only: [:index, :new, :create, :show, :destroy] do
        post :update_row_order, on: :collection
      end

      resources :variant_install_images do
        post :update_row_order, on: :collection
      end
    end

    resources :variant_types, except: [:show, :delete]

    resources :sku_prefixes, except: [:show, :delete]

    resources :skus, only: [] do
      get :next_available, on: :collection
      get :find_next_available, on: :collection
      get :validate, on: :collection
      get :validation, on: :collection
    end

  end

  namespace :api do
    namespace :v1 do

      resources :product_types, only: [:index, :show] do #, :create, :update, :destroy] do
        resources :collections, only: [:index, :show]
        # resources :product_type_images, only: :index, controller: :product_type_images
      end
      # resources :product_type_images, only: [:create, :destroy]

      resources :collections, only: [:index, :show] do #, :create, :update, :destroy] do
        resources :designs, only: [:index, :show]
        # resources :collection_images, only: :index, controller: :collection_images
      end
      # resources :collection_images, only: [:create, :destroy]

      resources :designs, only: [:index, :show] do #, :create, :update, :destroy] do
        resources :variants, only: [:index, :show]
      end
      # resources :design_images, only: [:create, :destroy]

    end
  end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
