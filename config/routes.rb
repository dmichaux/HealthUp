Rails.application.routes.draw do

	root 	 'static_pages#home'
	get  	 '/help',   to: 'static_pages#help'
	get  	 '/login',  to: 'sessions#new'
	post 	 '/login',  to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'

	resources :users do
		member do
			get :messages
		end
	end
	resources :account_activations, only: [:edit]
	resources :password_resets,		  only: [:new, :create, :edit, :update]
end
