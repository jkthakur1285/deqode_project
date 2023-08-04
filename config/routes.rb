Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # 
  resources :users
  resources :categories do
    resources :sub_categories
  end
  resources :products
  post 'login', to: "authentication#login"
end
