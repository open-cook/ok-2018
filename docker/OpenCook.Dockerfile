#
# ARM: docker build -t iamteacher/opencook.ru:ok.arm64 -f OpenCook.Dockerfile --build-arg BUILDPLATFORM="linux/arm64" ../
# AMD: docker build -t iamteacher/opencook.ru:ok.amd64 -f OpenCook.Dockerfile --build-arg BUILDPLATFORM="linux/amd64" ../
#
# docker run -ti iamteacher/opencook.ru:ok.arm64
# docker run -ti iamteacher/opencook.ru:ok.amd64

FROM --platform=$BUILDPLATFORM debian:10.13 as base_stage
ARG BUILDPLATFORM
RUN echo "$BUILDPLATFORM" > /BUILDPLATFORM

RUN apt-get update && \
    apt-get install --force-yes -y \
    build-essential

# Common software
RUN apt-get install --force-yes curl wget git htop ctop telnet
# For ruby
RUN apt-get install --force-yes libreadline-dev libz-dev
# For SQLite
RUN apt-get install --force-yes sqlite3 libsqlite3-0 libsqlite3-dev
# For MySql
RUN apt-get install --force-yes default-libmysqlclient-dev
# For PgSql
RUN apt-get install --force-yes libpq-dev

# Pygments / pygmentize -V
RUN apt-get install --force-yes -y python-pip && \
    pip install --upgrade Pygments

# IMAGE PROCESSORS
RUN apt-get install --force-yes -y \
    imagemagick libmagickwand-dev \
    advancecomp \
    gifsicle \
    jhead \
    jpegoptim \
    optipng \
    pngcrush \
    pngquant

# TEST ImageMagic
RUN curl https://upload.wikimedia.org/wikipedia/commons/b/bc/Juvenile_Ragdoll.jpg > /tmp/kitty.jpg && \
    convert /tmp/kitty.jpg /tmp/kitty.png && \
    identify /tmp/kitty.jpg /tmp/kitty.png

# Image to import some image processors
FROM ghcr.io/toy/image_optim:20221127 as image_optim

# Continue
FROM base_stage

RUN apt-get install --force-yes -y musl-dev
COPY --from=image_optim /usr/local/lib/libjpeg.so.9    /usr/local/lib/

COPY --from=image_optim /usr/local/bin/jpegtran        /usr/local/bin/
COPY --from=image_optim /usr/local/bin/jpeg-recompress /usr/local/bin/
COPY --from=image_optim /usr/local/bin/oxipng          /usr/local/bin/
COPY --from=image_optim /usr/local/bin/pngout          /usr/local/bin/

# For ruby 2.3.3
# https://unix.stackexchange.com/questions/688268/package-libssl1-0-0-has-no-installation-candidate
# http://snapshot.debian.org/binary/libssl1.0.0/
# https://launchpad.net/ubuntu/bionic/arm64/libssl1.0.0/1.0.2n-1ubuntu5.10

# OS architecture dependend libssl
COPY docker/libssl.install.sh /tmp/libssl.install.sh
RUN chmod +x /tmp/libssl.install.sh && /tmp/libssl.install.sh

# RUBY
RUN git clone https://github.com/rbenv/rbenv.git /opt/.rbenv && \
    git clone https://github.com/rbenv/ruby-build.git /opt/.rbenv/plugins/ruby-build

ENV RBENV_ROOT=/opt/.rbenv
ENV PATH=$PATH:/opt/.rbenv/bin:/opt/.rbenv/shims

RUN /opt/.rbenv/bin/rbenv install 2.3.3 && \
    /opt/.rbenv/bin/rbenv global 2.3.3

RUN echo 'eval "$(rbenv init - qemu)"' > ~/.bashrc

# CREATE GROUP `lucky`
RUN groupadd -g 7777 lucky

# CREATE USER `lucky`
RUN adduser lucky \
    -u 7777 \
    --ingroup lucky \
    --home /home/lucky \
    --shell /bin/bash \
    --disabled-password --gecos ''

RUN usermod -G lucky root
RUN usermod -G lucky lucky

RUN chown -R lucky:lucky /opt/.rbenv

USER lucky
WORKDIR /home/lucky
RUN echo 'eval "$(rbenv init - qemu)"' > ~/.bashrc

RUN gem install bundler -v 1.17.3 --verbose --no-ri --no-rdoc --no-document
RUN bundle config --global github.https true
RUN git config --global --add safe.directory /home/lucky

COPY Gemfile /home/lucky/Gemfile
COPY Gemfile.lock /home/lucky/Gemfile.lock

COPY X_GEMS /home/lucky/X_GEMS
COPY plugins /home/lucky/plugins

USER root

# [BUILDPLATFORM="linux/amd64"] has to be before Mysql/PGSQL
# or will produce `qemu: uncaught target signal 11`
SHELL ["/bin/bash", "--login", "-c"]
ENV NVM_DIR="/opt/.nvm"
RUN mkdir /opt/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
RUN nvm install 18.12.1
RUN chown -R lucky:lucky /opt/.nvm

USER lucky
SHELL ["/bin/bash", "-c"]
ENV NVM_DIR="/opt/.nvm"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

EXPOSE 3000/tcp
RUN bundle
