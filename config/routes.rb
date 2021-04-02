Rails.application.routes.draw do
  root 'users#new'
  resouces :users, only: %i[new create delete show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
