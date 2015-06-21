source 'https://rubygems.org'

ruby File.read('.ruby-version').strip

gem 'rails-i18n'
gem 'rails'
gem 'pg'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'

gem 'figaro'
gem 'devise'
gem 'devise-i18n'
gem 'rack-timeout'


group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'brakeman', require: false
  gem 'quiet_assets'
end

group :development, :test do
  gem 'byebug'
  gem 'web-console'
  gem 'spring'
  gem 'rubocop'
  gem 'did_you_mean'
  gem 'awesome_print'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'codeclimate-test-reporter', require: nil
end

group :production do
  gem 'puma'
  gem 'rails_12factor'
end
