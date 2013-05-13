Dvhk::Application.routes.draw do
  
  resources :shift_trackings do
    post 'edit_individual', :on => :collection
    put 'update_individual', :on => :collection
  end


  resources :reports

  #  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :priorities
  resources :briefingposts, :except => [:delete] do
    get 'deactive', :on => :member
  end
  devise_for :users, :controllers => {:passwords => "passwords"}
  resources :users, :only => [:show, :index]
  resources :passwords

  resources :data_files, :except => [:delete] do
    get 'shift_tracking', :on => :collection
    post 'create_shift_tracking', :on => :collection
    get 'day_off', :on => :collection
    post 'create_day_off', :on => :collection
  end
  
  resources :flights do
    post 'edit_individual', :on => :collection
    put 'update_individual', :on => :collection
    put 'update_multiple', :on => :collection
    get 'assigned', :on => :collection
    put 'assign', :on => :member
  end
  
  resources :arrival_flights do
    post 'edit_individual', :on => :collection
    put 'update_individual', :on => :collection
    put 'update_multiple', :on => :collection
    get 'assigned', :on => :collection
    get 'open', :on => :collection
    put 'assign', :on => :member
    put 'deactive', :on => :member
    put 'revert', :on => :member
    put 'approval_multiple', :on => :collection
    get 'history', :on => :member
    get 'assign_other', :on => :member
  end
  
  resources :working_shift_staffs

  resources :arrival_flights do
    resources :outbounds, :except => :destroy do
    end
  end
  
  resources :notices, :except => [:delete] do
    get 'deactive', :on => :member
  end
  resources :routings do
    resources :passengers, :except => :destroy do
      get 'show_accepted', :on => :collection
      get 'show_cleared', :on => :collection
      get 'accept', :on => :member
      get 'clear', :on => :member
      put 'unclear', :on => :member
      put 'accept_selected', :on => :collection
    end
  end

  resources :roles
  
  authenticated :user do
    root :to => 'briefingposts#index'
  end

  root :to => 'briefingposts#index'
end
