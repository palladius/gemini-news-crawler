# frozen_string_literal: true

Rails.application.routes.draw do
  get 'pages/about'
  get 'pages/audio'   #Testing auidio, not functional, 22aug24
  get 'pages/assistant'
  get 'pages/chat'
  get 'pages/graphs'
  get 'pages/search'
  get 'pages/gcp'
  get 'pages/demo-news-retriever'
  get 'pages/stats' => 'pages#gcp' # obsolete -> go to GCP

  resources :chats

  resources :articles
  resources :categories
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  get 'statusz' => 'rails/health#show', as: :rails_health_check_v2

  # Queries
  #  get '/smart_queries', to: 'smart_queries#index', as: 'smart_queries'
  resources :smart_queries
  get '/smart_queries/show', to: 'smart_queries#show' # , as: 'smart_queries'
  #  get 'smart_queries/index'

  # Defines the root path route ("/")
  # root "articles#index"
  root 'pages#about'
end
