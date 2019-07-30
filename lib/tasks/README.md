## Что делает data_obfuscation.rake

Скрипт предназначен для обфускации базы данных текущего окружения, чтобы можно было передать приближенный слепок production'а для локальной разработки. 

## Что нужно для выполнения скрипта

Скопируйте директорию `config/config.examples/ENV/temporarily` и переместите ее в `config/ENV/temporarily`. В `config/database.yml` добавьте окружение `temporarily`:

```ruby
temporarily:
  adapter: postgresql
  encoding: unicode
  database: open_cook_temporarily
  pool: 5
```

После этого запустите `rake data_obfuscation:run`, скрипт отключит на время выполнения колбеки Sphinx, создаст дамп базы данных текущего окружения и переместит их в `open_cook_temporarily`, удалит персональные данные пользователей, заказы и т.д. После успешного выполнения база данных `open_cook_temporarily` будет удалена и в`tmp` будет создан архив `the_app_obfuscated_data.tar.gz` внутри которого будет копия public с картинками и дамп с обфусцированными данными.

## Как использовать архив

Для загрузки дампа выполните 

```ruby
rake db:create

pg_restore --verbose --clean --no-owner --no-acl --dbname open_cook_dev PATH_TO_DUMP_FILE # заменить на путь к дампу

rake db:migrate
```

Директорию public переместите в корень проекта.
