Brello::Application.routes.draw do
  root to: 'root#root'
  
  resource :session
  
  resources :users do
    resources :boards
  end
  
  resources :boards do
    resources :memberships, only: [:create, :destroy]
    resources :lists#, only: [:create, :index, :new]
  end
  
  resources :lists do
    # Using nested resources to conform to backbone collection url pattern.
    resources :cards#, only: [:create, :index, :new]
  end
  
  resources :cards do
    resources :checklists
  end
  
  resources :checklists do
    resources :checklist_items
  end
  
  resources :memberships
end
