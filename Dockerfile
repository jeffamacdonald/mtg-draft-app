# Use Ubuntu-based Ruby image instead of Alpine to avoid native extension issues
FROM ruby:3.3.0

WORKDIR /app

ARG RAILS_ENV=development
ARG BUNDLE_WITHOUT=development
ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT=${BUNDLE_WITHOUT}

# Install PostgreSQL 14 repository for newer version
RUN apt-get update && apt-get install -y wget ca-certificates && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install Node.js and Yarn repositories
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install system dependencies including newer PostgreSQL
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    make \
    libc6-dev \
    libpq-dev \
    postgresql-client-14 \
    postgresql-14 \
    nodejs \
    yarn \
    libffi-dev \
    libssl-dev \
    libyaml-dev \
    ruby-dev \
    zlib1g-dev \
    liblzma-dev \
    libgmp-dev \
    libreadline-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libsqlite3-dev \
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
