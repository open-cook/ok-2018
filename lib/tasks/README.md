## Что делает `data_obfuscation:run`

Скрипт предназначен для обфускации базы данных текущего окружения, чтобы можно было передать приближенный слепок production'а для локальной разработки.

## Что нужно для выполнения скрипта

**1.** Скопировать `config/config.examples/ENV/temporarily` в `config/ENV/temporarily`.

```
cp -R config/config.examples/ENV/temporarily config/ENV/temporarily
```

**2.** В `config/database.yml` добавьте окружение `temporarily`

```ruby
temporarily:
  adapter: postgresql
  encoding: unicode
  database: open_cook_temporarily
  pool: 5
```

**3.** Запустить `rake data_obfuscation:run`

Скрипт сделает следующее:

- отключит на время выполнения колбеки Sphinx
- создаст дамп базы данных текущего окружения и переместит их в `open_cook_temporarily`
- удалит персональные данные пользователей, заказы и т.д.

После успешного выполнения:

- удалит базу данных `open_cook_temporarily`
- в`tmp` будет создан архив `obfuscated_data.tar.gz`

`obfuscated_data.tar.gz` содержит копию `public` и дамп с обфусцированными данными.

## Как использовать архив

Предполагаем, что:

- Пользователь находится в корне репозитория
- `obfuscated_data.tar.gz` находится в каталоге `./tmp`

Для загрузки дампа выполните:

- `rake data_obfuscation:setup`
