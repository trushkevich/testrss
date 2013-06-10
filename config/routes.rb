Testrss::Application.routes.draw do

  get "search/index"

  post '/favourites' => 'favourites#add_to_favourites', as: :add_to_favourites
  delete '/favourites' => 'favourites#remove_from_favourites', as: :remove_from_favourites


  resources :articles do
    collection do
      get :favourite, as: :favourite
    end
    member do
      get :comments
      post :add_comment
    end
  end


  post '/subscriptions' => 'subscriptions#create', as: :subscribe
  put '/subscriptions/:channel_id' => 'subscriptions#update', as: :update_subscription
  delete '/subscriptions' => 'subscriptions#destroy', as: :unsubscribe


  resources :channels do
    collection do
      get :subscribed, as: :subscribed
    end
    member do
      get :articles
    end
  end


  devise_for :users, :controllers => {
    :omniauth_callbacks => "omniauth_callbacks",
    :registrations => "registrations",
  }

  devise_scope :user do
    put '/users' => 'registrations#update', as: :update_user_registration
    get '/users/crop' => 'registrations#crop', as: :crop
    get '/users/recrop' => 'registrations#recrop', as: :recrop
    get '/users/profile' => 'registrations#show', as: :profile
    get '/crop' => 'registrations#crop', as: :user_crop
    get '/profile' => 'registrations#show', as: :user_root
  end

  # resources :users

  get "site/index"



  match '*path', :to => 'application#routing_error'


  root to: 'articles#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root to: 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
