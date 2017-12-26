FROM ruby:2.4
WORKDIR /app/
COPY Gemfile Gemfile.lock ./
RUN apt-get update && bundle install
COPY ./ ./
CMD ["ruby", "main.rb"]