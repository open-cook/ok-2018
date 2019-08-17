# docker build -t open-cook-dev .
# docker run -it open-cook-dev bash
#
# docker ps -aq -- List all containers (only IDs)
# docker stop $(docker ps -aq) -- Stop all running containers
# docker rm $(docker ps -aq) -- Remove all containers
# docker rmi $(docker images -q) -- Remove all images
# docker volume ls -- sharing file system between dockers
# docker volume prune -f -- remove all volumes

FROM debian:jessie-slim
LABEL maintainer="Ilya N. Zykin (zykin-ilya@ya.ru)"

RUN apt-get update

# XTERM

ENV TERM xterm
ENV DEBIAN_FRONTEND=noninteractive

# USE BASH SHELL BY DEFAULT

SHELL ["/bin/bash", "-c"]

# MINIMAL SOFT PACK

RUN apt-get install -y sudo screen dialog apt-transport-https ca-certificates
RUN apt-get install -y man-db deborphan aptitude bc bash-completion command-not-found
RUN apt-get install -y python-software-properties htop nmon iotop dstat vnstat unzip zip unar pigz
RUN apt-get install -y p7zip-full logrotate wget curl w3m lftp rsync openssh-server telnet nano mc
RUN apt-get install -y pv less sysstat ncdu ethtool dnsutils mtr-tiny rkhunter ntpdate ntp vim tree

# REQUIREMENTS LIBS

RUN apt-get install -y build-essential autoconf bison checkinstall git-core
RUN apt-get install -y libodbc1 libc6-dev libreadline6 libreadline6-dev libsqlite3-0 libsqlite3-dev
RUN apt-get install -y libssl-dev libxml2 libxml2-dev libxslt-dev libxslt1-dev libxslt1.1
RUN apt-get install -y libyaml-dev openssl sqlite3 zlib1g zlib1g-dev wget locales
RUN apt-get install -y debconf gawk libffi-dev libgdbm-dev libncurses5-dev libgmp-dev

# SET LANG VARS

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf

ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8

RUN locale-gen -y en_US.UTF-8
RUN dpkg-reconfigure locales

# MYSQL

# DEFAULT LOG FILES: /var/log/mysql.err, /var/log/mysql.log, /var/log/mysql/error.log

ENV MYSQL_ROOT_PASSWORD password
ENV MYSQL_USER_NAME open_cook_dev
ENV MYSQL_USER_PASSWORD password
ENV MYSQL_DB_NAME open_cook_dev

RUN debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
RUN debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"

RUN apt-get install -y mysql-server mysql-common mysql-client libmysqlclient-dev ruby-mysql

ENV MYSQL_DIRS_PERMITS="chown -R mysql:mysql /var/lib/mysql /var/lib/mysqld"
ENV MYSQL_START="service mysql start"

RUN mkdir -p /var/lib/mysqld

RUN $MYSQL_DIRS_PERMITS; $MYSQL_START; \
  mysql_install_db --user mysql > /dev/null

RUN $MYSQL_DIRS_PERMITS; $MYSQL_START; \
  mysql --password=$MYSQL_ROOT_PASSWORD --database=mysql --raw --batch --skip-column-names --execute=" \
    CREATE USER '$MYSQL_USER_NAME'@'localhost' IDENTIFIED BY '$MYSQL_USER_PASSWORD'; \
    CREATE DATABASE $MYSQL_DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci; \
    GRANT ALL PRIVILEGES ON $MYSQL_DB_NAME.* TO '$MYSQL_USER_NAME'@'localhost' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0; \
    SHOW GRANTS FOR '$MYSQL_USER_NAME'@'localhost'; \
"

# PSQL

RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN apt-get update
RUN apt-get install -y postgresql postgresql-contrib libpq-dev

USER postgres

ENV PSQL_USER_NAME=open_cook_dev
ENV PSQL_USER_PASSWORD=password
ENV PSQL_DB_NAME=open_cook_dev
ENV PG_START="pg_ctlcluster 11 main start"

RUN $PG_START && \
  psql -U postgres -c " \
  CREATE USER $PSQL_USER_NAME WITH PASSWORD '$PSQL_USER_PASSWORD'; \
  ALTER ROLE $PSQL_USER_NAME WITH CREATEDB;"; \
  createdb -E UTF8 -O $PSQL_USER_NAME $PSQL_DB_NAME; \
  psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE $PSQL_DB_NAME TO $PSQL_USER_NAME;"

USER root

# SPHINX SEARCH

ENV SPHINX_VERSION=2.2.11-release-1

WORKDIR /tmp

RUN wget http://sphinxsearch.com/files/sphinxsearch_$SPHINX_VERSION~jessie_amd64.deb
RUN apt-get install -y libmysqlclient18 libpq5
RUN dpkg -i sphinxsearch_$SPHINX_VERSION~jessie_amd64.deb
RUN rm -rf ./sphinxsearch*
RUN searchd -h | grep Sphinx

# NODE
# https://github.com/nodesource/distributions

ENV NODE_VERSION=8
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash -
RUN apt-get install -y nodejs

# SETUP VIM VARIABLES

RUN echo "set nocompatible" > ~/.vimrc
RUN echo ":set backspace=indent,eol,start" >> ~/.vimrc

# ADDITIONAL SOFTWARE

RUN apt-get install -y redis-server
RUN apt-get install -y imagemagick libmagickwand-dev
RUN apt-get install -y python-pip
RUN pip install --upgrade Pygments

# IMAGE OPTIMIZERS

RUN apt-get install -y advancecomp gifsicle jhead jpegoptim libjpeg-progs optipng pngquant

# PNGCRUSH. SEE FAILED BINS LIST
# http://www.rubydoc.info/gems/image_optim/ImageOptim/BinResolver/Bin

WORKDIR /tmp/
RUN wget https://netcologne.dl.sourceforge.net/project/pmt/pngcrush/1.8.11/pngcrush-1.8.11.tar.gz
RUN tar -xvf pngcrush-1.8.11.tar.gz
WORKDIR /tmp/pngcrush-1.8.11
RUN make pngcrush
RUN cp /tmp/pngcrush-1.8.11/pngcrush /usr/local/bin/pngcrush
WORKDIR /tmp/
RUN rm -rf ./pngcrush*

# SVGO
RUN npm install -g svgo

# PNGOUT

WORKDIR /tmp/
RUN wget http://static.jonof.id.au/dl/kenutils/pngout-20150319-linux.tar.gz
RUN tar -xvf pngout-20150319-linux.tar.gz
RUN cp /tmp/pngout-20150319-linux/x86_64/pngout /usr/local/bin/pngout
RUN rm -rf ./pngout-20150319*

# RVM

ENV RVM_RUBY_VERSION=ruby-2.3.3
ENV RVM_GEMSET_NAME=open_cook_dev

RUN gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io | bash -s stable
RUN /usr/local/rvm/bin/rvm requirements

RUN echo "source /usr/local/rvm/scripts/rvm" >> ~/.bash_profile
RUN echo "source /usr/local/rvm/scripts/rvm" >> ~/.bashrc

SHELL ["/bin/bash", "-l", "-c"]

RUN rvm -v

RUN rvm autolibs disable
RUN rvm install $RVM_RUBY_VERSION

RUN (rvm use $RVM_RUBY_VERSION) && (rvm gemset use $RVM_GEMSET_NAME --create)
RUN rvm $RVM_RUBY_VERSION@$RVM_GEMSET_NAME do gem install bundler

# CHECK SOFT

RUN wget https://raw.githubusercontent.com/DeployRB/SetupServer/master/article-2/check_soft_script.sh
RUN source check_soft_script.sh

# DEBIAN_FRONTEND to default

ENV DEBIAN_FRONTEND=

# CMD to run services

RUN echo $PG_START >> /root/run-services
RUN echo $MYSQL_DIRS_PERMITS >> /root/run-services
RUN echo $MYSQL_START >> /root/run-services
RUN chmod +x /root/run-services

WORKDIR /open-cook

CMD source /root/run-services && /bin/bash
