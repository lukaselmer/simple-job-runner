Rails.application.routes.draw do
  resources :runs
  get 'home/index'
  get 'home/check'

  root 'home#index'
end
