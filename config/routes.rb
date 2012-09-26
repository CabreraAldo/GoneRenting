ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  map.resource :user_session,:collection => [:create => :get]
  
  map.resource :account, :controller => "users"
  map.resources :users
  map.resources :portals
  map.resources :invite_tokens
  map.resources :bills, :collection => { :fetch_portal_users => :post}
  map.resources :tasks
  map.resources :comments
  map.oauth_callback "/fb_oauth/create", :controller=>"user_sessions", :action=>"create"


  map.edit_comment "/comments/edit/:id/:comment_id", :controller => 'comments', :action => 'edit'
  map.destroy_comment "/comments/destroy/:id/:comment_id", :controller => 'comments', :action => 'destroy'
  map.edit_task "/tasks/edit/:id/:task_id", :controller => 'tasks', :action => 'edit'
  map.destroy_task "/tasks/destroy/:id/:task_id", :controller => 'tasks', :action => 'destroy'
  map.user_create "/user/create", :controller => 'users', :action => 'create'
  map.user_session_create "/login/create", :controller => 'user_sessions', :action => 'create'
  map.signup 'signup', :controller => 'users', :action => 'new'
  map.new_signup '/user/signup', :controller => 'users', :action => 'new_signup'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.new_create '/user/create', :controller => 'users', :action => 'new_create'
  map.homepage '/homepage', :controller => "welcome", :action => "homepage"
  map.portal_bills '/portal/bills/modify/:id', :controller => "bills", :action => "portal_bills"
  map.bill_update 'bills/update/:id/:bill_id', :controller => "bills", :action => "update"
  map.user_all_bills 'user/bills/:id', :controller => "bills", :action => "all_bills_of_user"
  
  map.dashboard '/:portal_name/:id/dashboard', :controller => "portals", :action => "show"

  map.activate_account '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.send_activation 'send_activation(/:user_id)' , :controller => 'users', :action => 'send_activation'
  map.forgot_password 'forgot_password', :controller => 'user_sessions', :action => 'forgot_password'
  #  get
  map.forgot_password_submit 'forgot_password_submit', :controller => 'user_sessions' , :action => 'forgot_password_lookup_email'
  # post

  map.reset_password_submit 'reset_password_submit/:reset_password_code' , :controller => 'users', :action => 'reset_password_submit'
  map.reset_password 'reset_password/:reset_password_code' , :controller => 'users', :action => 'reset_password'
  


  map.show_invite_token '/invitations/:portal_id/:token', :controller => 'invite_tokens', :action => 'show'
  map.invite_token_new_user '/invitations/:portal_id/:token/signup', :controller => 'invite_tokens', :action => 'new_user'
  map.invite_token_create_user '/invitations/:portal_id/:token/create_user', :controller => 'invite_tokens', :action => 'create_user'
  map.invite_token_login_user '/invitations/:portal_id/:token/login', :controller => 'invite_tokens', :action => 'login_user'
  map.invite_token_create_user_session '/invitations/:portal_id/:token/create_user_session', :controller => 'invite_tokens', :action => 'create_user_session'

  map.accept_invite_token '/invitations/:portal_id/:token/accept', :controller => 'invite_tokens', :action => 'accept'

  map.create_invite_token '/invitations/:portal_id/create', :controller => 'invite_tokens', :action => 'create'
  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "welcome", :action => "index"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
