# frozen_string_literal: true

Rails.application.routes.draw do
  root 'statuses#index'

  get '/statuses', to: 'statuses#index'
  get '/status/new', to: 'statuses#new'
  get '/status/:id', to: 'statuses#show', as: 'status'
  get '/status/:id/edit', to: 'statuses#edit', as: 'status_edit'

  post '/statuses', to: 'statuses#create'

  patch '/status/:id', to: 'statuses#update'
end
