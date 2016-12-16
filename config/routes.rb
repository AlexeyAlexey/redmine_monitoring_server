# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :monitoring_server_results, only: [:index] do
  get :build_filter_form, on: :collection
end

resources :monitoring_server_settings