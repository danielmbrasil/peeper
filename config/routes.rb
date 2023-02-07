# frozen_string_literal: true

Rails.application.routes.draw do
  root 'statuses#index'

  get '/statuses', to: 'statuses#index'
end
