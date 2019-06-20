FROM ruby:2.6.3-slim

WORKDIR /client

RUN apt-get update \
  && apt-get install -y tree vim wget jq make ruby-dev gcc patch

COPY Gemfile* ./
RUN gem install bundler \
  && bundle install -j4

COPY . ./
