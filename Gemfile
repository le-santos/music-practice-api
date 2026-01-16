source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.10'
gem 'rails', '~> 8.1.0'

gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'devise', '~> 4.9'
gem 'dotenv-rails'
gem 'jwt'
gem 'pg', '~> 1.1'
gem 'propshaft'
gem 'puma', '~> 6.0'
gem 'pundit'
gem 'rack-cors'
gem 'tailwindcss-rails', '~> 2.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'timecop', '~> 0.8.1'
end

group :development do
  gem 'faker'
  gem 'listen', '~> 3.3'
  gem 'rails-erd'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'spring'
end

group :test do
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
