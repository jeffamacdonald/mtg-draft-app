# Use the official Ruby image
FROM ruby:3.4.4-alpine

WORKDIR /app

ARG RAILS_ENV=development
ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle"

RUN apk add --no-cache bash \
      curl \
      build-base \
      gcompat \
      nodejs \
      postgresql-dev \
      postgresql-client \
      libc6-compat \
      linux-headers \
      yaml-dev \
      glib-dev \
      musl-dev \
      gcc \
      g++ \
      make \
      pkgconfig \
      autoconf \
      automake \
      libtool \
      binutils \
      gmp-dev \
      mpfr-dev \
      mpc1-dev \
      tzdata \
      yarn \
      sed \
      ruby-dev \
      openssl-dev \
      libffi-dev \
      zlib-dev && rm -rf /var/cache/apk/*

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
