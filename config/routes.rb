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

    get 'product_exports/generate_csv', to: 'product_exports#generate_csv', as: 'product_export_generate_csv', defaults: { format: 'csv' }
    resources :product_exports, only: :index

    get 'order_limits_exports/generate_csv', to: 'order_limits_exports#generate_csv', as: 'order_limits_export_generate_csv', defaults: { format: 'csv' }
    resources :order_limits_exports, only: :index

    resources :colors, except: :show do
      post :update_row_order, on: :collection
    end

    resources :lead_times, except: :show do
      post :update_row_order, on: :collection
    end

    resources :substrates, except: :show, concerns: :paginatable do
      post :update_row_order, on: :collection
      resources :substrate_images, only: [:index, :new, :create, :show, :destroy] do
        post :update_row_order, on: :collection
      end
    end

    resources :substrate_categories, except: :show

    resources :backing_types, concerns: :paginatable do
      post :update_row_order, on: :collection
    end

    resources :users

    resources :websites, except: [:show, :delete]

    resources :styles, except: [:show, :delete]

    resources :vendors, except: [:show, :delete]

    resources :sale_units, except: [:show, :delete]

    resources :properties

    resources :product_types, concerns: :paginatable do
      post :update_row_order, on: :collection
      # resources :product_type_images, only: [:index, :new, :create, :show, :destroy] do
      #   post :update_row_order, on: :collection
      # end
    end

    resources :product_categories, concerns: :paginatable do
      post :update_row_order, on: :collection
    end

    get 'collections/search', to: 'collections#search'

    resources :collections, concerns: :paginatable do
      resources :designs, concerns: :paginatable, controller: :collection_designs do
        post :update_row_order, on: :collection
      end
    end

    resources :designs, only: [] do

      resources :design_styles #, only: :index

      resources :design_images, only: [:index, :new, :create, :show, :destroy] do
        post :update_row_order, on: :collection
      end

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
      resources :variant_images, only: [:index, :new, :create, :show, :destroy] do
        post :update_row_order, on: :collection
      end
    end

    resources :variant_types, except: :show

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
