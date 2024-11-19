# README

## How to start the application
1) cd into project
2) run `cp config/database-sample.yml config/database.yml` to specify the db template
3) run `bundle install` and `yarn install`
4) create the database with `bin/rails db:create`
5) migrate the database with `bin/rails db:migrate RAILS_ENV=development`
6) start the application with `bundle exec rails s`
7) in a seperate terminal window, run `bin/shakapacker-dev-server` to start shakapacker which will serve and load client side requests.

## readme template
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

