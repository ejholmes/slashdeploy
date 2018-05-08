source 'https://rubygems.org'

ruby '2.2.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.7.1'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'virtus'
gem 'pg'
gem 'postgres_ext'
gem 'oj'
gem 'puma'
gem 'sass'

# Github API Client Library.
# We are pinning to a specific git hash to gain access to behavior in
# this PR: https://github.com/octokit/octokit.rb/pull/996
gem 'octokit', git: 'https://github.com/octokit/octokit.rb.git', ref: 'f2a5ff176447afc61caa0e0d95b0cd02c031512f'

# Used for interacting with Slack API.
gem 'faraday', '0.9.1'
gem 'faraday_middleware'

# async worker.
gem 'sidekiq'

# Visibility
gem 'rollbar', '~> 2.8.0'
gem 'lograge'
gem 'dogstatsd-ruby'

# Auth
gem 'jwt'
gem 'warden'
gem 'oauth2'
gem 'omniauth'
gem 'omniauth-oauth2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails', '~> 3.0'
  gem 'rspec-activemodel-mocks'
  gem 'rubocop', '~> 0.49.0'

  gem 'pry',                       '0.10.3'
  gem 'pry-rails',                 '0.3.4'
end

group :test do
  gem 'webmock', require: false
  gem 'capybara'
  gem 'codeclimate-test-reporter', require: nil
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'foreman'
  gem 'brakeman'
  gem 'dotenv-rails', '~> 2.2'
end
