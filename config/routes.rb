Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :merchants do
    member do
      get 'dashboard'
    end
    scope module: "merchants" do
      resources :items, only: [:index]
      resources :invoices, only: [:index, :show]
    end
  end

  get '/admin', to: 'admins#dashboard' 
  shallow do 
    namespace :admin do 
      resources :merchants, :invoices

    end
  end
end
