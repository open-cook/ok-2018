# docker build -t open_cook/pgsql:latest -f Dockerfile.PgSQL .
# docker run -ti open_cook/pgsql:latest
FROM --platform=linux/amd64 open_cook/base
RUN apt-get install --force-yes -y postgresql libpq-dev

CMD ["tail -f /dev/null"]
