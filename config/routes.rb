Rails3::Application.routes.draw do
  devise_for  :users,
              :controllers => { :sessions => "user_sessions" },
              :path_names => { :sign_in => 'login', :sign_out => 'logout',  :registration => 'register' }

  # The priority is based upon order of creation:
  # first created -> highest priority.
  resources :profiles

  resources :users do
     member do
       get :edit_password 
       get :set_login
       put :update_login
       put :update_password
       get :edit_email
       put :update_email
       get :edit_avatar
       put :update_avatar
    end
  end

  resources :announcements
  
  # RESTful rewrites
  
  match  '/opensession' => "sessions#create", :as => "open_id_complete", :requirements => { :method => :get }
  match '/opencreate' => 'users#create',:as => :open_id_create,  :requirements => { :method => :get }
    
  
  # Administration
  namespace :admin do 
    root :to => 'dashboard#index'
    match '/settings/update_settings' => 'settings#update_settings',  :requirements => { :method => :post }
    match '/users/search' => 'users#search',  :requirements => { :method => :get }

    resources :announcements
    resources :commits
    resources :delayed_jobs, :only => [:index]
    resources :settings 
    
    resources :users do 
      member do 
        put :suspend
        put :unsuspend
        put :activate
        delete :purge
        put :reset_password
        get :set_user_login
        get :set_user_email
        post :addrole
        delete :removerole
        match 'role/:role' => "users#toggle_role", :as => "toggle_role"
      end
      collection do
        get :pending
        get :active
        get :suspended
        get :deleted
        get :filter
      end
    end
    
    resources :roles do
      member do 
        post :adduser
        delete :removeuser
	  end 
  	end

    resources :orgs do
      collection do
        get  :edit_school
        post :update_school
      end

    end

    resources :grades
    resources :sclasses do
      member do 
        post :add_student
        post :add_teacher
        delete :removeuser
	  end 
    end
  end
  
  match '/auth/:provider/callback' => 'authentications#create', :as => :auth_callback
  resources :authentications
  
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
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
  # root :to => "welcome#index"
  root :to => "dashboard#index"
  
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
