source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

gem 'less-rails'
gem 'twitter-bootstrap-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'annotate'
gem 'figaro', '<= 0.7.0'
gem 'config'
gem 'simple_form'
gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'jpmobile'
gem 'twitter', git: 'https://github.com/sferik/twitter.git', branch: 'master'
gem 'i18n_generators'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'houston'
gem 'exception_notification'
gem 'slack-notifier'
gem 'exception_notification-rake'
gem 'sinatra'
gem 'carrierwave'
gem 'rmagick'
gem 'whenever', :require => false
gem 'ruby_rncryptor'

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-stack_explorer'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rspec-rails', '~> 3.1.0'
  gem 'capybara'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'shoulda-matchers', '~> 2.7.0', require: false
  gem 'rspec-collection_matchers', '~> 1.0.0'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'faker'
  gem 'faker-japanese'
  gem 'test_after_commit'
end

group :development do
  # Deploy with Capistrano
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano3-unicorn'
  gem 'capistrano-sidekiq'
  gem 'web-console', '~> 2.0'
end
