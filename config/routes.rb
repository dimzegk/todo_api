# frozen_string_literal: true

Rails.application.routes.draw do
  post '/signup', to: 'users#create'

  post '/auth/login', to: 'authentication#login'
  get  '/auth/logout', to: 'authentication#logout'

  resources :todos, only: %i[index create show update destroy] do
    get    'items/:iid', to: 'todo_items#show'
    post   'items',      to: 'todo_items#create'
    put    'items/:iid', to: 'todo_items#update'
    delete 'items/:iid', to: 'todo_items#destroy'
  end
end
