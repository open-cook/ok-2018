FROM ruby:2.3-jessie

ENV APP_HOME=/app
ENV BUNDLER_GEMFILE=/app/Gemfile
ENV BUNDLE_PATH=/gems
ENV LANG=C.UTF-8
ENV LANGUAGE="$LANG"
ENV LC_ALL="$LANG"
ENV TZ=Europe/Moscow

RUN mkdir $APP_HOME \
    && echo "en_US ISO-8859-1"     >  /etc/locale.gen \
    && echo "en_US.UTF-8 UTF-8"    >> /etc/locale.gen \
    && echo "en_US.UTF-8 UTF-8"    >> /etc/locale.gen \
    && echo "ru_RU ISO-8859-5"     >> /etc/locale.gen \
    && echo "ru_RU.CP1251 CP1251"  >> /etc/locale.gen \
    && echo "ru_RU.KOI8-R KOI8-R"  >> /etc/locale.gen \
    && echo "ru_RU.UTF-8 UTF-8"    >> /etc/locale.gen \
    && echo "ru_RU.UTF-8 UTF-8"    >> /etc/locale.gen \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apt-get update \
    && apt-get install -y \
        libmysqlclient-dev \
        libpq-dev \
        libssl-dev \
        locales \
        mysql-client \
        nodejs \
        postgresql-client \
        sqlite3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
ADD . $APP_HOME

RUN gem install bundler -v 1.17.3 \
    && bundle install --deployment --without development test --with plugins --jobs=3

EXPOSE 3000
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
