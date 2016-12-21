source 'https://rubygems.org'


# Sprockets 3.0 sucks!
gem 'sprockets', '~> 2.8'

# All Groups

gem 'rails', '4.1.6'
gem 'rake', '10.1.0'
gem 'sqlite3'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

gem 'jquery-rails'
#gem 'turbolinks'
#gem 'jquery-turbolinks'
gem 'jquery-datatables-rails'
#, '~> 2.2.1'

gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'friendly_id'
gem 'redcarpet'

gem 'foundation-rails', '5.4.3.1'
gem 'font-awesome-rails'

gem 'devise'
gem 'devise-async'
gem 'country_select', github: 'stefanpenner/country_select'
gem 'cancancan'
gem 'rack-affiliates'

gem 'rqrcode_png'
gem 'bitcoin-client', github: 'BillyParadise/bitcoin-client', branch: 'master'

gem 'sidekiq', '~>3.2.2'
gem 'sinatra', require: false
gem 'slim'
gem 'sidetiq'

gem 'httparty'
gem 'simple_form', '~> 3.0'

gem 'turnout'
gem 'morrisjs-rails'
gem 'raphael-rails'

  group :development do
  gem 'therubyracer',  platforms: :ruby
  gem 'spring'
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  gem 'thin'
  gem 'capistrano',  '~> 3.1'
  gem 'capistrano-rvm'
  gem 'capistrano-rails', '~> 1.1'
  gem 'brakeman', :require => false
  gem 'pry'
  gem 'pry-doc'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'spring-commands-rspec'
  gem 'guard-rspec'
end

group :test do
#  gem 'faker'
  gem 'capybara-webkit'
end


group :production do
	gem 'passenger'
  gem 'mysql2'
end

