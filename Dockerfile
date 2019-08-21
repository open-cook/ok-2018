FROM ruby:2.3

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV development

RUN wget http://sphinxsearch.com/files/sphinx-2.2.9-release.tar.gz
RUN tar -zxvf sphinx-2.2.9-release.tar.gz
RUN cd sphinx-2.2.9-release && ./configure --with-pgsql --with-mysql && make && make install

COPY Gemfile /usr/src/app/


COPY Gemfile.lock /usr/src/app/

COPY . /usr/src/app/

RUN bundle install
