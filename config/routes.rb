Rails.application.routes.draw do
  root 'users#new'
  resources :users, only: %i[new create destroy edit update show]
  get 'login', to: 'authentication#new'
  post 'login', to: 'authentication#create'
  delete 'logout', to: 'authentication#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
