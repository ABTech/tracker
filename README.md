# AB Tech Tracker

The tech tracker is a specialized web application used internally by Carnegie Mellon University's Activities Board Technical Committee. Its major features are event planning/organization, incoming email management, financial tracking, and membership management (including payroll and timecard generation). It was originally written in ~2003 in perl-style Rails 1.x, and through the years has been taken over and upgraded by various techies.

The current version of Tracker uses Ruby 2.7.5 and Rails 6.1.7. The OS sendmail is used for sending emails, and Sphinx is used for searching events.

## Development Notes

Work on large new features should be done in branches and/or forks; smaller changes can be done in `master`. The `production` branch should always be deployable.

A Devise configuration file is required for the membership model. One can be generated with the command `rails g devise Member`. The generated configuration (and therefore, the membership data in the database) may not be compatible with production Tracker. If using a copy of the production database, this may mean you will either have to edit some records with `rails c` to allow you to log in, or request a copy of the production Devise configuration file. See setup instructions below.

You must install Sphinx if you wish to use the event search feature. You can then generate an index by running the command `rails ts:index` on the server.

You must install and configure a sendmail provider if you wish to send emails from Tracker.

## Development Setup

### Initial Setup

1. Install Docker
1. Install MySQL
1. Create MySQL databases `abtt_development_master` and `abtt_test`
1. Create a MySQL user `abtt` with a password of your choice, and
give it access to those databases.

### Making Changes

1. Clone the repo and checkout the intended branch
1. Make changes
1. Build the Docker image: `docker build --tag "tracker" --platform linux/amd64 .`
1. Run the image:
   ```
   docker run -d \
   -e RAILS_ENV=development \
   -e DATABASE_URL='mysql2://abtt:mypassword@host.docker.internal/abtt_development_master' \
   -p 3000:3000 tracker
   ```
1. Now you can open tracker at `http://localhost:3000`


If this is your first run, do the following:

1. Set a variable with the output of the run command:
   `export CONTAINER=paste_output_here`
1. Load the DB schema: `docker exec $CONTAINER ./bin/rails db:schema:load`
1. Load the DB schema: `docker exec $CONTAINER ./bin/rails db:seed`
1. Enter Rails console: `docker exec -it $CONTAINER ./bin/rails c`
1. Create an initial user:
    ```ruby
    Member.create(namefirst: "Sam", namelast: "Abtek", email: "abtech@andrew.cmu.edu", phone: "5555555555", password: "password", password_confirmation: "password", payrate: 0.0, tracker_dev: true)
    exit
    ```

### Configuration

You may use the following environment variables when running the image:

- `RAILS_ENV` - development, staging, production, etc.
- `DATABASE_URL` - e.g. `mysql2://abtt:password@host.docker.internal/abtt_development_master`


## Deployment

The intended directory structure is as follows. `/srv/abtech-tracker` may be moved anywhere if you override the systemd service/socket files, and the `production-01` and `staging-01` may be any name (these are the instance names).
```
/srv
├── abtech-tracker
│   ├── production-01
│   │   ├── corepack
│   │   ├── pids
│   │   ├── rbenv
│   │   ├── repo
│   │   ├── run
│   │   └── tracker.env
│   └── staging-01
│       ├── corepack
│       ├── pids
│       ├── rbenv
│       ├── repo
│       ├── run
│       └── tracker.env
```

1. Determine an instance name (like `production-01`) and create the above directory path. Clone into the `repo` folder and change to that directory.
2. Copy [`tracker.env`](./deploy/tracker.env) to the parent of `repo`. Change any variables inside that need to be changed.
3. From the `repo` directory as root: `set -o allexport; source ../tracker.env; set +o allexport`
4. `rbenv install`
5. `../rbenv/shims/gem install --no-document bundler`
6. `rbenv rehash`
7. Create a user `deploy-abtech-tracker`. This user does not need `sudo`, a home folder, or a default shell.
8. Create a MySQL user `deploy-abtech-tracker` authenticated via UNIX socket. Create a database `abtech_tracker_<instance name>`. Grant all permissions on the database to the user.
9. Now login as the `deploy-abtech-tracker` user: `sudo -u deploy-abtech-tracker` /bin/bash
10. As deploy-abtech-tracker: `set -o allexport; source ../tracker.env; set +o allexport`
11. As deploy-abtech-tracker: `../rbenv/shims/bundle config set --local deployment 'true'`
12. As deploy-abtech-tracker: `../rbenv/shims/bundle install`
13. As deploy-abtech-tracker: Copy in the production or staging master key and run `EDITOR=nano ../rbenv/shims/bundle exec rails credentials:edit --environment production` (or staging) and make sure it looks right. Ensure it is up to date with the example at [config/credentials/example.yml](./config/credentials/example.yml).
14. As deploy-abtech-tracker: `../rbenv/shims/bundle exec rails db:environment:set RAILS_ENV=production`
15. As deploy-abtech-tracker: `../rbenv/shims/bundle exec rails db:create` (may already exist)
16. As deploy-abtech-tracker: `../rbenv/shims/bundle exec rails db:schema:load`
17. As deploy-abtech-tracker: `../rbenv/shims/bundle exec rails db:seed`
18. As deploy-abtech-tracker: `yarn install`
19. As deploy-abtech-tracker: `../rbenv/shims/bundle exec rails assets:precompile`
20. As deploy-abtech-tracker: `../rbenv/shims/bundle exec rails ts:index`
21. As deploy-abtech-tracker: `../rbenv/shims/bundle exec rails c`
    ```ruby
    Member.create(namefirst: "Sam", namelast: "Abtek", email: "abtech@andrew.cmu.edu", phone: "5555555555", password: "password", password_confirmation: "password", payrate: 0.0, tracker_dev: true)
    exit
    ```
22. Now as `root`:
    ```
    systemctl enable abtech-tracker@production-01.socket abtech-tracker@production-01.service abtech-tracker-ts@production-01.service abtech-tracker-email-idle@production-01.service abtech-tracker-ts-index@production-01.timer abtech-tracker-slack-notify@production-01.timer
    ```
23. As `root`:
    ```
    systemctl start abtech-tracker-ts@production-01.service abtech-tracker@production-01.socket abtech-tracker@production-01.service abtech-tracker-email-idle@production-01.service
    ```

### Email pulling

Tracker includes a rake task called `email:idle` which will connect to a Gmail account and continuously pull email from it in the background. To do so, you need to get a client ID/secret from Google, and generate a refresh token for the Gmail account you want to authenticate with. Note: if you do not use the `email:idle` task, the following instructions are unnecessary.

1. Go to the [Google APIs console](https://code.google.com/apis/console/), select "APIs & auth > Credentials", and click Create new Client ID.
2. Choose "Installed Application", and then "Other". If you are requested to set up a Consent screen, enter an email address and a product name, and continue.
3. Once you have a Client ID and Client secret, download the [oauth2.py tool](https://github.com/google/gmail-oauth2-tools/wiki/OAuth2DotPyRunThrough).
4. `python oauth2.py --generate_oauth2_token --client_id=CLIENT_ID --client_secret=CLIENT_SECRET`
   
   Make sure to replace CLIENT_ID and CLIENT\_SECRET with the appropriate values.
5. Among the output will be a value labeled "refresh token". Use this and the client ID and secret to update your secrets file (see the `credentials:edit` task in the development and deployment instructions above). An example can be found at [config/credentials/example.yml](./config/credentials/example.yml).
