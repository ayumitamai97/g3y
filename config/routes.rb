# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'root#index'

  post '/graphql', to: 'graphql#execute'
end
