# Release

An application to make managing releases to specific environments easier.

## Getting started

You will need a SQL database and may have to create an app-specific SQL user - check `config/database.yml` for user details.

    bundle install
    rake db:create
    rake db:reset
    rake db:migrate
    rake spec