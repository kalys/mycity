FROM ruby:2.4
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN apt-get update && apt-get install -y nodejs && bundle install
COPY ./ ./
RUN rake assets:precompile
EXPOSE 3000
CMD ["puma", "-C", "config/puma_deploy.rb"]