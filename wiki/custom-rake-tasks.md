# Custom Rake Tasks
## Local Tasks
### `db:full_reset`
This task can be used locally, when switching between different branches which have differing migrations.

It runs the rake tasks `db:drop`, `db:create`, `db:migrate`, and `db:seed` to restore the database to the base state of the branch that you are on.

### `db:seed clear_first=yes`
Run this task to clear the DB before seeding.

## Deployment Tasks
(Precede all of these with `bundle exec cap demo`)
### `deploy:reseed`
Runs `db:seed clear_first=yes` on the deployment database.