# Use the official Ruby image
FROM ruby:3.3.0-alpine

# Set the working directory in the container
WORKDIR /app

# Install dependencies
RUN apk add --no-cache bash \
      build-base \
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
RUN bundle install

# Install yarn
COPY package.json yarn.lock ./
RUN yarn install

# Copy the rest of the application code
COPY . .

# Compile assets
RUN bundle exec rails assets:precompile

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
