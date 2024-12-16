Rails.application.routes.draw do
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
  }
  namespace :admin do
   get '/admin', to: 'homes#top'
   resources :genres, only: [:index, :edit, :create, :update]
   resources :items, only: [:index, :new, :create, :show, :edit, :update]
  end

  scope module: :public do
   devise_for :customers, skip: [:passwords], controllers: {
   registrations: "public/registrations",
   sessions: 'public/sessions'
   }
   
   root to: "homes#top"
   
   get "customers/mypage" => "customers#show", as: "mypage"
   get "/customers/information/edit" => "customers#edit"
   get "/customers/check" => "customers#check"
   
   patch 'customers/withdraw' => 'customers#withdraw', as: 'withdraw_customer'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
 end
end
