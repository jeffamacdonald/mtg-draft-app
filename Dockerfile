# Use the official Ruby image
FROM ruby:3.4.4-alpine AS base

WORKDIR /app

ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle"

# Install runtime dependencies only
RUN apk add --no-cache \
      bash \
      curl \
      gcompat \
      nodejs \
      postgresql-client \
      libc6-compat \
      tzdata \
      yarn \
      openssl \
      libffi \
      zlib && \
    rm -rf /var/cache/apk/*

# Build stage - install build dependencies
FROM base AS builder

# Install build dependencies
RUN apk add --no-cache \
      build-base \
      linux-headers \
      yaml-dev \
      postgresql-dev \
      ruby-dev \
      openssl-dev \
      libffi-dev \
      zlib-dev && \
    rm -rf /var/cache/apk/*

RUN gem install bundler:2.7.2

COPY Gemfile Gemfile.lock ./
RUN if [ "$RAILS_ENV" = "production" ]; then \
      bundle install --verbose --without development test; \
    else \
      bundle install --verbose; \
    fi

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

# Only precompile bootsnap and assets in production
RUN if [ "$RAILS_ENV" = "production" ] || [ -z "$RAILS_ENV" ]; then \
      echo "Compiling assets..." && \
      bundle exec bootsnap precompile app/ lib/ && \
      yarn build:css && \
      SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile --trace; \
    else \
      echo "Skipping asset compilation for $RAILS_ENV"; \
    fi

# Final stage - copy from builder and use minimal runtime image
FROM base AS final

# Copy the built application
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

EXPOSE 3000

CMD ["sh", "-c", "rm -f tmp/pids/server.pid && ./bin/rails server"]
