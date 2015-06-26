Rails.application.routes.draw do
  get 'visualizations/x_vs_score/:x', to: 'visualizations#x_vs_score'

  resources :runs do
    collection do
      get 'start_random_pending_run'
      get 'end_all'
      post 'schedule_runs'
    end
    member do
      put 'report_results'
      get 'restart'
    end
  end

  get 'home/index'
  get 'home/check'

  root 'home#index'
end
