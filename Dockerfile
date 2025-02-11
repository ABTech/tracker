FROM ruby:3.0.7

# install RVM
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2
RUN gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \curl -sSL https://get.rvm.io | bash -s stable && /bin/bash

# install ruby
ENV RUBY_VERSION=3.0.7
RUN /bin/bash -l -c "rvm install $RUBY_VERSION && rvm --default use $RUBY_VERSION"

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash && apt-get install -y --no-install-recommends nodejs

# Create working directory
WORKDIR /build

# Install chromium
RUN apt-get update && apt-get install -y --no-install-recommends chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

COPY . /build/

RUN gem install bundler
# RUN rbenv rehash
RUN RAILS_ENV=development bundle install
# RUN rbenv rehash
RUN npm install -g yarn
RUN yarn install
RUN RAILS_ENV=development rails assets:precompile

# Expose port 3000 to the outside world
EXPOSE 3000

# The command to run the app
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && rails server -b 0.0.0.0"]

# To build this image, run `docker-compose build` in the terminal
