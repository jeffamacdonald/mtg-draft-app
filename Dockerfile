# Use Ubuntu-based Ruby image instead of Alpine to avoid native extension issues
FROM ruby:3.3.0

WORKDIR /app

ARG RAILS_ENV=development
ARG BUNDLE_WITHOUT=development
ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT=${BUNDLE_WITHOUT}

# Install Node.js and Yarn repositories and update package lists
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    nodejs \
    yarn \
    libffi-dev \
    libssl-dev \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler:2.3.3
COPY Gemfile Gemfile.lock ./
RUN bundle install --verbose

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

# Only precompile bootsnap and assets in production
RUN echo "RAILS_ENV is: $RAILS_ENV" && \
    if [ "$RAILS_ENV" = "production" ] || [ -z "$RAILS_ENV" ]; then \
      echo "Compiling assets..." && \
      bundle exec bootsnap precompile app/ lib/ && \
      SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile --trace; \
    else \
      echo "Skipping asset compilation for $RAILS_ENV"; \
    fi

EXPOSE 3000

CMD ["sh", "-c", "rm -f tmp/pids/server.pid && ./bin/rails server"]
