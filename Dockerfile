# Use the official Ruby image
FROM ruby:3.3.0-alpine

WORKDIR /app

ARG RAILS_ENV=development
ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

RUN apk add --no-cache bash \
      curl \
      build-base \
      gcompat \
      nodejs \
      postgresql-dev \
      postgresql-client \
      libc6-compat \
      tzdata \
      yarn \
      sed && rm -rf /var/cache/apk/*

RUN gem install bundler:2.3.3
COPY Gemfile Gemfile.lock ./
RUN bundle install --verbose

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

# Only precompile bootsnap and assets in production
RUN if [ "$RAILS_ENV" != "development" ]; then \
      bundle exec bootsnap precompile app/ lib/ && \
      SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile --trace; \
    fi

EXPOSE 3000

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:3000/up || exit 1

CMD ["sh", "-c", "rm -f tmp/pids/server.pid && ./bin/rails server"]
