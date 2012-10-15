# FassetsCore

This project rocks and uses MIT-LICENSE.

# Install

To use this plugin in your rails project, you need to add the gem to your applications `Gemfile`:

```
gem 'fassets_core'
```

After that, run the `bundle` command to install all new dependencies.

Then you need to install and run the migrations:

```
bundle exec rake fassets_core_engine:install:migrations
bundle exec rake db:migrate
```

# Run tests

In order to run the tests for the first time, you need to do the following in a clean repository:

```
bundle
RAILS_ENV=test rake db:migrate
bundle exec guard
```

After the initial setup, it is okay to just start guard:

```
bundle exec guard
```

