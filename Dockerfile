# Use Ubuntu-based Ruby image instead of Alpine to avoid native extension issues
FROM ruby:3.3.0

WORKDIR /app

ARG RAILS_ENV=development
ARG BUNDLE_WITHOUT=development
ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT=${BUNDLE_WITHOUT}

# Install system dependencies for repository setup
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    lsb-release \
    gnupg \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install PostgreSQL 14 repository with modern keyring method
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    gpg --dearmor -o /etc/apt/keyrings/postgresql.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install Node.js 20 and Yarn repositories with modern keyring method
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    wget --quiet -O - https://dl.yarnpkg.com/debian/pubkey.gpg | \
    gpg --dearmor -o /etc/apt/keyrings/yarn.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

# Install system dependencies including newer PostgreSQL
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client-14 \
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
