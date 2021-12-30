# AB Tech Tracker

The tech tracker is a specialized web application used internally by Carnegie Mellon University's Activities Board Technical Committee. Its major features are event planning/organization, incoming email management, financial tracking, and membership management (including payroll and timecard generation). It was originally written in ~2003 in perl-style Rails 1.x, and through the years has been taken over and upgraded by various techies.

The current version of Tracker uses Ruby 2.5.0 and Rails 5.2.6. Postfix is used for sending emails, and Sphinx is used for searching events.

## Development Notes

Work on large new features should be done in branches and/or forks; smaller changes can be done in `master`. The `production` branch should always be deployable.

A few steps are required to start developing with Tracker. You can install all of the required gems using the command `bundle install`. Rails requires you to generate a secret key which cannot be stored in source control. Running `rake secret` will generate a token, after which you should create a file `config/secrets.yml` with the following text, where `X` is your generated secret token:

```yaml
development:
  secret_key_base: X
test:
  secret_key_base: X
production:
  secret_key_base: X
```

Optimally, each `X` should be a different value.

A Devise configuration file is required for the membership model. One can be generated with the command `rails g devise Member`. The generated configuration (and therefore, the membership data in the database) may not be compatible with production Tracker. If using a copy of the production database, this may mean you will either have to edit some records with `rails c` to allow you to log in, or request a copy of the production Devise configuration file.

Tracker does not currently have a database seed, so if you are not provided with a copy of the production database, you need to create a database yourself. The only data required for running the app is a member object that you can log in as. After you have configured the `config/database.yml` file to point to a local empty MySQL database, you can run the command `rake db:schema:load` to create the required tables, and you can use `rails c` to load a console with which you can create a Member object. The syntax for doing so is similar to the following:

```ruby
Member.create(namefirst: "First Name", namelast: "Last Name", email: "abtech@andrew.cmu.edu", phone: "5555555555", password: "password", password_confirmation: "password", payrate: 0.0, tracker_dev: true)
```

You must install Sphinx if you wish to use the event search feature. You can then generate an index by running the command `rails ts:rebuild` on the server.

You must install Postfix if you wish to send emails from Tracker. No configuration for Postfix is required.

### Email pulling

Tracker includes a rake task called `email:idle` which will connect to a Gmail account and continuously pull email from it in the background. To do so, you need to get a client ID/secret from Google, and generate a refresh token for the Gmail account you want to authenticate with. Note: if you do not use the `email:idle` task, the following instructions are unnecessary.

1. Go to the [Google APIs console](https://code.google.com/apis/console/), select "APIs & auth > Credentials", and click Create new Client ID.
2. Choose "Installed Application", and then "Other". If you are requested to set up a Consent screen, enter an email address and a product name, and continue.
3. Once you have a Client ID and Client secret, download the [oauth2.py tool](https://github.com/google/gmail-oauth2-tools/wiki/OAuth2DotPyRunThrough).
4. `python oauth2.py --generate_oauth2_token --client_id=CLIENT_ID --client_secret=CLIENT_SECRET`
   
   Make sure to replace CLIENT_ID and CLIENT\_SECRET with the appropriate values.
5. Among the output will be a value labeled "refresh token". Use this and the client ID and secret to create a configuration file (which should be located at `config/email.yml`):

```yaml
---
  :email: "user@gmail.com"
  :name: "inbox"
  :port: 993
  :host: 'imap.gmail.com'
  :ssl: true
  :refresh_token: "REFRESH_TOKEN"
  :client_id: "CLIENT_ID"
  :client_secret: "CLIENT_SECRET"
```

### GroupMe notifications

Tracker can send text messages to a GroupMe chat about upcoming calls and strikes for events that have a "textable" flag set. To enable this, you must set up a [GroupMe bot](https://dev.groupme.com/) and put the bot ID string in a configuration file, which should be located at `config/groupme.yml`:

```yaml
---
  :bot_id: "BOT_ID"
```

## Deployment

Capistrano is used for deployment. Configuration is included in source control which can be used for deployment to both [the staging server](https://abtech.andrew.cmu.edu/tracker-staging/) and [production](https://abtech.andrew.cmu.edu/tracker/). The canonical servers deploy under the `abtech` account, which you must be able to login to via public-key authentication.

Examples of commands:
```shell
cap staging deploy                        # Deploy the master branch to tracker-dev
cap production deploy                     # Deploy the production branch to tracker
cap production thinking_sphinx:rebuild    # Rebuild the production search index
cap production thinking_sphinx:restart    # Restart the production search daemon
cap production foreman_systemd:restart    # Restart the production email pulling daemon
```
