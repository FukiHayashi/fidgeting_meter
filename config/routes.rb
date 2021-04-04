Rails.application.routes.draw do
  get 'authentication/new'
  get 'authentication/create'
  get 'authentication/destory'
  root 'users#new'
  resources :users, only: %i[new create destroy edit update show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
