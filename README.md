# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Complete Ruby on Rails Framework Guide


1. Installation and Setup
Prerequisites
# Required software
- Ruby (3.0.0 or newer)
- Rails (7.0.0 or newer)
- PostgreSQL
- Node.js
- Yarn

Installation Steps
# Install Ruby (Windows)
1. Download RubyInstaller from https://rubyinstaller.org/
2. Run the installer and follow the prompts
3. Make sure to check "Add Ruby to PATH"

# Install Rails
gem install rails

# Verify installations
ruby -v
rails -v

2. Creating a New Rails Project
# Create new project with PostgreSQL
rails new githublite --database=postgresql
(OR Exitsting empty project) rails new . --database=postgresql

# Navigate to project directory
cd myapp

# Install dependencies
bundle install

rails server -p 3001

3. Database Configuration
PostgreSQL Setup
Install PostgreSQL
Create a user and set password
Configure config/database.yml:
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: myapp_development
  username: postgres
  password: postgres
  host: localhost
  port: 5432

test:
  <<: *default
  database: myapp_test
  username: postgres
  password: postgres
  host: localhost
  port: 5432

production:
  <<: *default
  database: myapp_production
  username: myapp
  password: <%= ENV['MYAPP_DATABASE_PASSWORD'] %>

Database Commands
# Create databases
rails db:create

# Run migrations
rails db:migrate

# Reset database
rails db:reset

# Seed database
rails db:seed
