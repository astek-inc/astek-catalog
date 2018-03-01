Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root 'admin/categories#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  namespace :admin do

    resources :users

    get 'clients/generate_token' => 'clients#generate_token'
    resources :clients, except: :show

    resources :properties

    resources :variant_types, except: :show

    resources :categories, concerns: :paginatable do
      post :update_row_order, on: :collection
      resources :category_images, only: [:index, :new, :create, :show, :destroy], controller: :category_images do
        post :update_row_order, on: :collection
      end
    end

    resources :collections, concerns: :paginatable do
      post :update_row_order, on: :collection

      resources :collection_images, only: [:index, :new, :create, :show, :destroy], controller: :collection_images do
        post :update_row_order, on: :collection
      end

      resources :designs, concerns: :paginatable do
        post :update_row_order, on: :collection
      end
    end

    resources :designs, concerns: :paginatable do

      resources :design_properties  do #, controller: :design_properties do
        put :assign, on: :collection
        post :update_row_order, on: :collection
      end

      resources :variants, concerns: :paginatable do
        post :update_row_order, on: :collection
      end
    end

    resources :variants, concerns: :paginatable do
      resources :variant_images, only: [:index, :new, :create, :show, :destroy] do #, controller: :variant_images do
        post :update_row_order, on: :collection
      end
    end

  end

  namespace :api do
    namespace :v1 do

      resources :categories, only: [:index, :show] do #, :create, :update, :destroy] do
        resources :collections, only: [:index, :show]
        # resources :category_images, only: :index, controller: :category_images
      end
      # resources :category_images, only: [:create, :destroy]

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
