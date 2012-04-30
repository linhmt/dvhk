Dvhk::Application.routes.draw do
  #  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :priorities
  resources :briefingposts, :except => [:delete] do
    get 'deactive', :on => :member
  end
  devise_for :users, :controllers => {:passwords => "passwords"}
  resources :users, :only => [:show, :index]
  resources :passwords

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  resources :flights
  resources :arrival_flights
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

  authenticated :user do
    root :to => 'briefingposts#index'
  end

  root :to => 'briefingposts#index'
end
