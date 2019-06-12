source 'http://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 4.0.0'

# Use mysql as the database for Active Record
gem 'mysql2'
gem "devise"
gem "redis"
gem "resque", require: "resque/server"
gem "rails_config"
gem "ransack"
gem "websocket-rails"

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem "jquery-rails"
gem "jquery-ui-rails", ">= 6.0.0"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
gem 'kaminari'
gem 'state_machine'

group :development do
  gem "capistrano", "~> 3.2.1"
  gem "capistrano-rvm"
  gem "capistrano-rails"
  gem "capistrano-bundler"
  gem "capistrano-resque", github: "sshingler/capistrano-resque", require: false
  gem 'binding_of_caller'
  gem "thin"
  gem "pry-byebug"
  gem "better_errors"
  # gem 'ckeditor'
  # gem 'paperclip'
end

group :staging, :production do
  gem "unicorn"
end
