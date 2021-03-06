Rails.application.routes.draw do
  get 'visualizations/x_vs_score/:x', to: 'visualizations#x_vs_score', as: :x_vs_score
  get 'visualizations/x_vs_score/:x/:z', to: 'visualizations#x_vs_score_by_z', as: :x_vs_score_by_z

  resources :run_groups, only: %i(index show)

  resources :runs, only: %i(index show) do
    collection do
      get 'possible_pending'
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
