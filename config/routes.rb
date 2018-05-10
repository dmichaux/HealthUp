Rails.application.routes.draw do

	root 	 'static_pages#home'
	get  	 '/help',    to: 'static_pages#help'
	get		 '/contact', to: 'outside_messages#new'
	post	 '/contact', to: 'outside_messages#create'
	get  	 '/login',   to: 'sessions#new'
	post 	 '/login',   to: 'sessions#create'
	delete '/logout',  to: 'sessions#destroy'

	resources :users do
		member do
			get :messages
		end
	end
	resources :cohorts do
		member do
			get 	:select_users
			patch :add_users
		end
	end
	resources :account_activations, only: [:edit]
	resources :password_resets,		  only: [:new, :create, :edit, :update]
	resources :messages,						only: :create
end
