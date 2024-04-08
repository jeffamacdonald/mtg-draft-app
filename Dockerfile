# Use the official Ruby image
FROM ruby:3.1.0

# Set the working directory in the container
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client libxml2-dev libxslt1-dev

# Install gems
RUN gem install bundler:2.3.3
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application code
COPY . .

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]