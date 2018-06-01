FROM ruby:2.4
WORKDIR /app
ADD Gemfile Gemfile.lock ./
RUN apt-get update && apt-get install -y nodejs && bundle install
ADD ./ ./
RUN rake assets:precompile
EXPOSE 3000
CMD ["puma", "-C", "config/puma.rb"]
