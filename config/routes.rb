Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  resources :tags
  resources :posttags
  # https://railsguides.jp/routing.html ... 入れ子にすると「form_with に [@post, Comment.new] と配列で渡すと、Railsは「Post ID ◯◯ 番に紐づく新しい Comment を作るんだな」と判断し、内部で post_comments_path(@post) というメソッドを呼び出そうとします。」らしい gemini
  resources :posts do
    resources :comments, only: [ :create ]
  end
  resources :libraries, only: [:index, :show, :create]
  resources :search, only: [ :index, :show ]
  resources :settings, only: [ :index ]
  resources :timeline, only: [ :index ]
  resources :readings do
    collection do
      post :start
      patch :finish
    end
  end

  root to: "posts#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "search/show/:id", to: "search#show", as: "search_show"
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
