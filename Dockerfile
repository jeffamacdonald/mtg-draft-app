# Use the official Ruby image
FROM ruby:3.3.0-alpine

# Set the working directory in the container
WORKDIR /app

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Install dependencies
RUN apk add --no-cache bash \
      curl \
      build-base \
      gcomopat \
      nodejs \
      postgresql-dev \
      postgresql-client \
      libc6-compat \
      tzdata \
      yarn \
      sed && rm -rf /var/cache/apk/*

# Install gems
RUN gem install bundler:2.3.3
COPY Gemfile Gemfile.lock ./
RUN bundle install --verbose

# Install yarn
COPY package.json yarn.lock ./
RUN yarn install

# Copy the rest of the application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Compile assets
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile --trace

# Start the Rails server
EXPOSE 3000
CMD ["rm -f tmp/pids/server.pid"]
CMD ["./bin/rails", "server"]
