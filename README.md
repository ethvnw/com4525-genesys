# 2024-25 Genesys COM4525 Team 02

<table align="center"><tr><td align="center" width="9999">
<img src="https://i.ibb.co/FYvZ3vF/readme-hero.png" align="center" width="400" alt="Project Hero">
</td></tr></table>

## Introduction

Roamio is a collaborative app to organise trip tickets, bookings, and activities. It is implemented using Ruby on Rails

Key Features include:

- 💎 Built with Ruby on Rails
- 🔑 Authentication with Devise
- 🔒 Authorisation with CanCanCan
- 🎨 Front-end with Bootstrap
- ✅ Fully tested with RSpec and Capybara
- 📦 Database with PostgreSQL

## Installation
- Download [PostgreSQL 14](https://www.postgresql.org), [Ruby 3.3.4](https://www.ruby-lang.org/en/), [Bundler 2.5.17](https://bundler.io), and [Rails 7.0.8.4](https://rubyonrails.org)
- cd into `project/`
- Run `bin/setup`
- Start the application with `bundle exec rails s`
- In a separate terminal window, run `bin/shakapacker-dev-server` to start Shakapacker which will serve and load client side requests

## Default User Accounts
| Role | Email | Password |
| ---- | ----- | -------- |
| Product Owner | admin@genesys.com | AdminGenesys#1 |
| Reporter | reporter@genesys.com | ReporterGenesys#1 |
| Member | epigenesys@demo.com | EpiGenesys12! |

## API Keys
API Keys are defined in [development.yml.enc](./config/credentials/development.yml.enc).
| Root Key | Nested Keys | Key |
| ---- | ----- | -------- |
| unsplash | access_key | hMK_hhQIzWgodewx-3hKxsMy43G7fp6JjpmZ8OXSBjs |
| unsplash | secret_key | nHDKpgtamcRrqcz053Al6KJl58OpmX8mco1sWv4m86E |
| mapbox | username | jbur |
| mapbox | access_token | pk.eyJ1IjoiamJ1ciIsImEiOiJjbGg5NXR0cHkwMnEyM3JzM2RzMzAxM3oyIn0.-nxW5C88qcqvtLAbWVBIAw |

## Wiki
The Wiki provides helpful documentation and guidance for tools created to ease the development process:

- [Custom Rake Tasks](./wiki/custom-rake-tasks.md)
- [Routes and Controllers](./wiki/routes-and-controllers.md)
- [Test Middleware](./wiki/test-middleware.md)
- [Toasts](./wiki/toasts.md)
- [Turbo Streams](./wiki/forms/turbo-streams.md)
- [Validated Form Builder](./wiki/forms/validated-form-builder.md)


## Contributing & Code Standards
Details on contributing & code standards can be found in [CONTRIBUTING.md](./CONTRIBUTING.md)
