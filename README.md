# AB Tech Tracker

The tech tracker is a specialized web application used internally by Carnegie Mellon University's Activities Board Technical Committee. Its major features are event planning/organization, incoming email management, financial tracking, and membership management (including payroll and timecard generation). It was originally written in ~2003 in perl-style Rails 1.x, and through the years has been taken over and upgraded by various techies.

The current version of ABTT uses Ruby 2.0 and Rails 4.2. Postfix is used for sending emails, and Sphinx is used for searching events.

## Development Notes

Work on large new features should be done in branches and/or forks; smaller changes can be done in `master`. The `production` branch should always be deployable.

A few steps are required to start developing with ABTT. You can install all of the required gems using the command `bundle install`. Rails requires you to generate a secret key which cannot be stored in source control. Running `rake secret` will generate a token, after which you should create a file `config/secrets.yml` with the following text, where `X` is your generated secret token:

```yaml
development:
  secret\_key_base: X
test:
  secret\_key_base: X
production:
  secret\_key_base: X
```

Optimally, each `X` should be a different value.

A Devise configuration file is required for the membership model. One can be generated with the command `rails g devise Member`. The generated configuration (and therefore, the membership data in the database) may not be compatible with production ABTT. If using a copy of the production database, this may mean you will either have to edit some records with `rails c` to allow you to log in, or request a copy of the production Devise configuration file.

ABTT does not currently have a database seed, so if you are not provided with a copy of the production database, you need to create a database yourself. The only data required for running the app is a member object that you can log in as. After you have configured the `config/database.yml` file to point to a local empty MySQL database, you can run the command `rake db:schema:load` to create the required tables, and you can use `rails c` to load a console with which you can create a Member object. The syntax for doing so is similar to the following:

```ruby
Member.create(namefirst: "First Name", namelast: "Last Name", email: "abtech@andrew.cmu.edu", phone: "5555555555", aim: "", password: "password", password_confirmation: "password", payrate: 0.0, tracker_dev: true)
```

You must install Sphinx if you wish to use the event search feature. You can then generate an index by running the command `rake ts:rebuild`.

You must install Postfix if you wish to send emails from ABTT. No configuration for Postfix is required.

## Deployment

Capistrano is used for deployment. A `deploy.rb` file is included in source control which can be used for deployment to [tracker-dev](tracker-dev.abtech.org); the only change required is an authorized username in the `:user` field. The `deploy.rb` file can also be used to deploy to production by changing the domain to `tracker.abtech.org` and changing the branch to `production`.

```shell
cap deploy             # This will perform a normal deploy
cap deploy:migrations  # This will perform a deploy with migrations
                       #  (required if any database changes
                       #   occurred since last deploy)
```
