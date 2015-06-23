Rails.application.routes.draw do
  resources :runs do
    collection do
      get 'start_random_pending_run'
      get 'end_all'
      post 'schedule_runs'
    end
    member do
      put 'report_results'
    end
  end

  get 'home/index'
  get 'home/check'

  root 'home#index'
end
