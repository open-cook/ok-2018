#
# ARM:
# docker build -t iamteacher/rails4:2022.arm64 -f Rails4.2022.Dockerfile --build-arg BUILDPLATFORM="linux/arm64" ../
# docker run -ti iamteacher/rails4:2022.arm64
#
# AMD:
# docker build -t iamteacher/rails4:2022.amd64 -f Rails4.2022.Dockerfile --build-arg BUILDPLATFORM="linux/amd64" ../
# docker run -ti iamteacher/rails4:2022.amd64

FROM --platform=$BUILDPLATFORM debian:10.13 as base_stage
ARG BUILDPLATFORM
RUN echo "$BUILDPLATFORM" > /BUILDPLATFORM

RUN apt-get update && \
    apt-get install --force-yes -y \
    build-essential

# Common software
RUN apt-get install --force-yes -y curl wget git htop ctop telnet
# For ruby
RUN apt-get install --force-yes -y libreadline-dev libz-dev
# For SQLite
RUN apt-get install --force-yes -y sqlite3 libsqlite3-0 libsqlite3-dev
# For MySql
RUN apt-get install --force-yes -y default-libmysqlclient-dev
# For PgSql
RUN apt-get install --force-yes -y libpq-dev
# For Image optimizer
RUN apt-get install --force-yes -y musl-dev

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Pygments (Code Highlighting) / pygmentize -V
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

RUN apt-get install --force-yes -y python-pip && \
    pip install --upgrade Pygments

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Image Processors
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

RUN apt-get install --force-yes -y \
    imagemagick libmagickwand-dev \
    advancecomp \
    gifsicle \
    jhead \
    jpegoptim \
    optipng \
    pngcrush \
    pngquant

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Image to import some Image Processors
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

FROM ghcr.io/toy/image_optim:20221127 as image_optim

# Continue
FROM base_stage

COPY --from=image_optim /usr/local/lib/libjpeg.so.9    /usr/local/lib/

COPY --from=image_optim /usr/local/bin/jpegtran        /usr/local/bin/
COPY --from=image_optim /usr/local/bin/jpeg-recompress /usr/local/bin/
COPY --from=image_optim /usr/local/bin/oxipng          /usr/local/bin/
COPY --from=image_optim /usr/local/bin/pngout          /usr/local/bin/

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# OS specific LIBSSL (For the old Ruby)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

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

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# My Lucky User
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

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

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# RBENV and Ruby
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

ENV RBENV_ROOT=/opt/.rbenv
ENV PATH=$PATH:/opt/.rbenv/bin:/opt/.rbenv/shims

RUN /opt/.rbenv/bin/rbenv install 2.3.3 && \
    /opt/.rbenv/bin/rbenv global 2.3.3

RUN echo 'eval "$(rbenv init - qemu)"' > /root/.bashrc
RUN echo 'eval "$(rbenv init - qemu)"' > /home/lucky/.bashrc

RUN chown -R lucky:lucky /opt/.rbenv

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# NVM Node
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

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

# NODE. To update local .bashrc
RUN touch ~/.bash_profile
ENV NVM_DIR="/opt/.nvm"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

# RUN npm -g install svgo
