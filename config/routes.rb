# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'root#index'

  post '/graphql', to: 'graphql#execute'

  # SPA catch-all fallback
  get '*path', to: 'root#index'
end
