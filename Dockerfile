FROM ruby:3.1.3-alpine3.17

ENV TZ=Asia/Tokyo

ENV APP_ROOT /happy_hacks_backend

RUN mkdir -p ${APP_ROOT}

WORKDIR ${APP_ROOT}

COPY Gemfile Gemfile.lock ${APP_ROOT}/

RUN apk update && apk add --no-cache \
    libc6-compat \
    postgresql-client \
    tzdata \
    && apk add --no-cache --virtual .build-dependencies \
    build-base \
    postgresql-dev \
    && bundle config set --jobs 4 \
    && bundle install \
    && apk del .build-dependencies

COPY . ${APP_ROOT}