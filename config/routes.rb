Rails.application.routes.draw do
  get 'home/index'
  get 'home/check'

  root 'home#index'
end
