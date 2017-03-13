FROM ruby:2.3-slim
ENV PROJECT_FOLDER /docker_test
RUN apt-get update -qq && apt-get install -y build-essential apt-utils libpq-dev nodejs
RUN mkdir $PROJECT_FOLDER
WORKDIR $PROJECT_FOLDER
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
RUN bundle exec rake RAILS_ENV=$RAILS_ENV DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname ACTION_CABLE_ALLOWED_REQUEST_ORIGINS=foo,bar SECRET_TOKEN=dummytoken assets:precompile
VOLUME ["$INSTALL_PATH/public"]
CMD puma -C config/puma.rb
