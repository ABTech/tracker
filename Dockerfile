# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.0.6
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"


# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    libpq-dev  `# Part of generated dockerfile` \
    libvips  `# Generated for ActiveRecord` \
    node-gyp  `# Generated for Node` \
    pkg-config `# Generated for Node` \
    build-essential \
    curl \
    libmariadb-dev  # Needed by ActiveRecord

# Install JavaScript dependencies
ARG NODE_VERSION=16.13.1
ARG YARN_VERSION=1.22.19
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Install node modules
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# https://github.com/rails/rails/issues/32947#issuecomment-470380517
# Precompile assets
# We use dummy master.key and credentials.yml.enc to workaround the fact that
# assets:precompile needs them but we don't want the real master.key to be built
# into the container. We will inject RAILS_MASTER_KEY env var when starting the
# container.

# TODO: resolve this in a way that does not require running in development mode.
RUN /bin/bash -c 'if [[ "$RAILS_ENV" == "production" ]]; then \
      mv config/credentials/production.yml.enc config/credentials/production.yml.enc.backup && \
      SECRET_KEY_BASE_DUMMY=1 RAILS_ENV=development ./bin/rails assets:precompile && \
      mv config/credentials/production.yml.enc.backup config/credentials/production.yml.enc && \
      rm -f config/master.key; \
    fi'


# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    libvips  `# Generated for ActiveRecord` \
    curl \
    rsync `# Asset syncing` \
    libmariadb-dev `# activerecord` \
    nodejs `# js runtime` && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# https://serverfault.com/a/984599
USER root
RUN mkdir -p /srv/public \
 && chown -R rails:rails /srv/public
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-sync-assets-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
