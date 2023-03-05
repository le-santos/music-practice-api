FROM ruby:3.2.0-alpine

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN apk add --no-cache nodejs build-base tzdata postgresql-dev
RUN bundle install

EXPOSE 3000

CMD ["/bin/sh -c bundle exec rails s -b 0.0.0.0"]
