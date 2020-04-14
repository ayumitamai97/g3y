# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.6.5'

gem 'mysql2', '>= 0.4.4'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'elasticsearch-model'
gem 'elasticsearch-rails'

gem 'graphql'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails', '~> 4.0.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop-rails', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
