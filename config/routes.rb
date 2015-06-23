Rails.application.routes.draw do
  resources :runs do
    collection do
      get 'start_random_pending_run'
      get 'end_all'
      get 'schedule_runs'
    end
  end

  get 'home/index'
  get 'home/check'

  root 'home#index'
end
