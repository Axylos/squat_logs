FROM arm64v8/ruby:2.6.1-alpine

ENV BUILD_DEPS="curl tar wget linux-headers" \
    DEV_DEPS="build-base postgresql-dev zlib-dev libxml2-dev libxslt-dev readline-dev tzdata git nodejs"

RUN apk add --update --upgrade $BUILD_DEPS $DEV_DEPS

WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --system

ENV APP_ENV production
ADD . /app
RUN bundle install --system

EXPOSE 8080

CMD ["ruby", "app.rb", "-s", "Puma"]
