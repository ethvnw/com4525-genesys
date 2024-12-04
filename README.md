# 2024-25 Genesys COM4525 Team 02

<table align="center"><tr><td align="center" width="9999">
<img src="https://i.ibb.co/FYvZ3vF/readme-hero.png" align="center" width="400" alt="Project Hero">
</td></tr></table>

## Introduction

Roamio is a collaborative app to organise trip tickets, bookings, and activities. It is implemented using [Ruby on Rails](https://website-name.com)

Key features include:

- 💎 Built with Ruby on Rails
- 🔑 Authentication with Devise
- 🔒 Authorisation with CanCanCan
- 🎨 Front-end with Bootstrap
- ✅ Fully tested with RSpec and Capybara
- 📦 Database with PostgreSQL

## Installation
- Download [PostgreSQL 14](https://www.postgresql.org)
- cd into `project/`
- Run `cp config/database-sample.yml config/database.yml` to specify the db template
- Run `bundle install` and `yarn install` to download dependencies
- Create the database with `bin/rails db:create`
- Migrate the database with `bin/rails db:migrate RAILS_ENV=development`
- Start the application with `bundle exec rails s`
- In a seperate terminal window, run `bin/shakapacker-dev-server` to start Shakapacker which will serve and load client side requests
## Style Guides Used
## Contributing
- Create a branch following `type/[story number]-description` for the name
- Push commits following `type(scope): description` for the name
- Ensure your branch meets the style standards by running the pipelines `haml-lint`, `yarn eslint`, and `rubocop`.
- Create PRs using the provided template, squash commits and do not delete the branch.
