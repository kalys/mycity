FROM ruby:2.4
WORKDIR /app
RUN apt-get update && apt-get install -y nodejs
ADD Gemfile Gemfile.lock ./
RUN bundle install --jobs 20 --retry 5 --without development test
ADD ./ ./
RUN rake assets:precompile
EXPOSE 3000
CMD ["puma", "-C", "config/puma.rb"]
