FROM ruby:3.3.10-trixie

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libvips \
  nodejs \
  postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# RUN bundle install

EXPOSE 3000

CMD ["/bin/sh -c bundle exec rails s -b 0.0.0.0"]
