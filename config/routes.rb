Rails.application.routes.draw do
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  namespace :authentication, path: '', as: '' do
    resources :users, only: [ :new, :create ], path: '/register', path_names: { new: '/'}
    resources :sessions, only: [ :new, :create, :destroy ], path: '/login', path_names: { new: '/'}
  end

  namespace :administration, path: '', as: '' do
    resources :reports, only: [ :index ], path: '/reportes', path_names: { index: '/'}
    get 'modal_report_detail', to: 'reports#modal_report_detail', as: :modal_report_detail
  end
  
  resources :services
  resources :categories
  resources :user_types, except: :show
  resources :medical_sessions, only: [ :new, :create ]
  
  resources :appointments
  get 'medico', to: 'appointments#panel_medico', as: :medico
  get 'sucursal', to: 'appointments#panel_sucursal', as: :sucursal
  get 'modal_services', to: 'appointments#modal_services', as: :modal_services
  get 'finish_appointment', to: 'appointments#modal_finish_appointment', as: :finish_appointment
  get 'cancel_appointment', to: 'appointments#modal_cancel_appointment', as: :cancel_appointment
  get 'print_ticket', to: 'appointments#print_ticket', as: :print_ticket
  
  resources :permissions, path: '/'

  

  # Defines the root path route ("/")
  # root "posts#index"

  #Permissions
  #delete '/permisos/:id', to: 'permissions#destroy'
  #patch '/permisos/:id', to: 'permissions#update'
  #post '/permisos', to: 'permissions#create'
  #get '/permisos/new', to: 'permissions#new', as: :new_permission
  #get '/permisos', to: 'permissions#index', as: :permissions
  #get '/permisos/:id', to: 'permissions#show', as: :permission
  #get '/permisos/:id/edit', to: 'permissions#edit', as: :edit_permission
  
end
