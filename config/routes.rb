Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users,
             path: '',
             path_names: { sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'registration' },
             controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources  :users, only: [:show]

  resources :rooms, except: [:edit] do
    member do
      ## member runs the action for the speific room id, thats why we have rooms/id/listing
      get 'listing'
      get 'pricing'
      get 'description'
      get 'photo_upload'
      get 'amenities'
      get 'location'
    end
    resources :photos, only: %i[create destroy]
    resources :reservations, only: [:create]
  end
end
