FROM ruby:3.3.10-slim

WORKDIR /app

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libvips \
  nodejs \
  postgresql-client \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]