Rails.application.routes.draw do

	root 	 'static_pages#home'
	get  	 '/help',   to: 'static_pages#help'
	get  	 '/login',  to: 'sessions#new'
	post 	 '/login',  to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'

	resources :account_activations, only: [:edit]
end
