Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :promotions, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    member do
      post 'generate_coupons'
      post 'approve'
    end
    get 'search', on: :collection
  end

  resources :coupons, only: [] do
    post 'disable', on: :member
  end

  namespace :api, constrainsts: lambda { |req| req.format == :json } do
    namespace :v1 do
      resources :coupons, only: [:show], param: :code
    end
  end
end
