source 'https://rubygems.org'

ruby '2.5.7'

gem 'rails', '5.2.4.3'
gem 'active_model_serializers'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use postgresql as the database for Active Record
gem 'pg'
# Lock PG gem to 0.20 to suppress PGconn, PGresult, and PGError constant deprecation warning
#gem 'pg', '~> 0.20.0'

gem 'puma'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'paranoia', '~> 2.2'

gem 'ranked-model'
gem 'jquery-ui-rails'

gem 'kaminari'

# File uploads, image transformation, and Amazon S3 storage
gem 'fog-aws'
gem 'carrierwave', '~> 1.0'
gem 'mini_magick', '>= 4.9.4'

# Authentication and permissions
gem 'devise-bootstrap-views'
gem 'devise'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection' # mitigation against CVE-2015-9284
gem 'cancancan'
gem 'rolify'

gem 'data_migrate'

# PDF tearsheet generation
gem 'prawn-rails'

# Search
gem 'ransack', github: 'activerecord-hackery/ransack'

# Background jobs
gem 'sucker_punch'

# Conjugate verbs in controlller error messages
gem 'verbs'

# Keyword tags
gem 'acts-as-taggable-on', '~> 6.0'
gem 'twitter-typeahead-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# To use Jbuilder templates for JSON
gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'spring', group: :development

group :development, :test do
  gem 'listen'
  gem 'figaro'
end
