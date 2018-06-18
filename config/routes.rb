Rails.application.routes.draw do

	root 	 'static_pages#home'
	get  	 '/about',   to: 'static_pages#about'
	get  	 '/login',   to: 'sessions#new'
	post 	 '/login',   to: 'sessions#create'
	delete '/logout',  to: 'sessions#destroy'

	resources :users do
		member do
			get 	:messages
			patch :unassign_cohort
			patch :soft_delete
			patch :reactivate
		end
		delete  :destroy_soft_deleted, on: :collection
	end

	resources :cohorts do
		member do
			get 	:select_users
			patch :add_users
		end
	end

	resources :messages, only: :create do
		patch 	:open, on: :member
	end

	resources :outside_messages, only: [:new, :create] do
		patch		:open, on: :member
	end

	resources :account_activations, only: 	[:edit]
	resources :password_resets,		  only: 	[:new, :create, :edit, :update]
	resources :posts,								except: [:index, :show, :new]
	resources :comments,						only: 	[:create, :destroy]
	resources :user_goals, 					only: 	[:create, :destroy]
end
