Rails.application.routes.draw do

  # devise routes for user authentication
  devise_for :users, controllers: { registrations: 'registrations' }

  # root fot the dashboard
  root to: "app#index"
  
  get '/terms', to: 'app#terms'

  # collect reports
  post '/report/:token', to: 'reports#create'

  # turn alert emails off from a link in the email
  get '/alerts/:kind/unsubscribe/:token', to: 'alert_unsubscriptions#show', as: :alert_unsubscription
  post '/alerts/:kind/unsubscribe/:token', to: 'alert_unsubscriptions#create'

  # api used by the dashboard frontend
  namespace :api do
    resources :websites, only: [:index, :show, :create, :update]
    resources :reports, only: [:index] do
      collection do
        get :aggs
        get :time_series
      end
    end
    resources :users, only: [] do
      collection do
        get :me
        post :resend_confirmation
      end
    end
  end

end
