## Основные Зависимости

1. `RVM`
2. `Postgres` (Основная БД)
3. `MySQL` (Для связки со Sphinx)
4. `Ruby 2.3.3`
5. `Rails 4.2.7.1`
6. `Sphinx` (Поиск)
7. `ImageMagic` (Обработка изображений)
8. `Redis` (Кеширование)

### Дополнительные Зависимости (Опционально)

1. `python` (Для установки pygmentize)
2. `pygmentize` (Подсветка синтаксиса в публикациях)
3. `gifsicle`, `jhead`, `jpegoptim`, `jpegtran`, `optipng`, `pngcrush`, `pngout`, `pngquant`, `advpng`, `svgo` (Оптимизация изображений). Читай подробнее [ЗДЕСЬ](https://github.com/toy/image_optim)

:warning: [Установочный скрипт для Debian](https://github.com/DeployRB/SetupServer/blob/master/article-2/install_script.sh) В нем вы можете найти примеры того как и какое ПО устанавливалось на сервер, на котором на данный момент работает production версия проекта.

## Установка

Здравствуй, странник! Если ты читаешь это, то тебя занесло в прекрасную чащу леса с волшебными гемами и библиотеками, давай же начнем наш путь:

- `git clone git@github.com:open-cook/ok-2018.git open-cook.ru`
- `cd open-cook.ru`

### Начало установки

- `rvm install 2.3.3`
- `gem install bundler`
- `bundle install`

### Конфигурирование Проекта

Все конфигурационные файлы проекта собраны в одном месте. Это должно обеспечивать быстрый поиск нужных конфигов и их изменение.

Если вам требуется настроить какой-то сервис сзязанный с приложением или изменить какие-то настройки, то первое место  где вы должны попробовать их найти это: `config/ENV/{RAILS_ENVIRONMENT_NAME}`. Например, `config/ENV/development`:

Для первоначального запуска приложения достаточно скопировать каталоги и файлы конйигураций:

- `cp -R config/config.examples/ENV/ config/ENV`
- `cp config/config.examples/database.yml config/database.yml`

И, конечно, не забыть указать актуальные данные в `config/database.yml`.

Если вы не используете Docker, то удалите **host: postgres** из настроек development окружения.

Далее считаем, что имя БД: `open_cook_dev`

### Создать пустую Базу Данных

- `rake db:create`

### Скопировать Базу Данных

- `scp rails@188.166.94.234:~/DUMPS/open-cook.ru.rails_app_db.2019_07_25_12_01.pq.sql ./open-cook.ru.rails_app_db.2019_07_25_12_01.pq.sql`

_Пароль к серверу спросить у владельца репозитория_

### Загрузить Базу

- `pg_restore -d open_cook_dev -1 ~/Projects/open-cook.ru.rails_app_db.2019_07_25_12_01.pq.sql --no-privileges --no-owner`

### Скопировать файлы

- `mkdir -p ./public && rsync -chavzPr rails@188.166.94.234:/home/rails/www/open-cook.ru/production/SHARED/public/uploads ./public`

_Пароль к серверу спросить у владельца репозитория_

### Миграции

- `rake db:migrate`

### Индексация данных для Поиска

Ты молодец, уже немалый путь пройден, осталось совсем немного:

Sphinx поможет найти "сказочных фей" и сокровища в этом лесу.

- `sudo apt-get install sphinxsearch`

В каталоге приложения

- `rake ts:start`
- `rake ts:configure`
- `rake ts:index`

Вы должны увидеть что-то вроде:

```
indexing index 'recipe_core'...
WARNING: index 'recipe_core': dict=keywords and prefixes and morphology enabled, forcing index_exact_words=1
collected 635 docs, 3.7 MB
sorted 0.8 Mhits, 100.0% done
total 635 docs, 3699050 bytes
total 0.775 sec, 4772395 bytes/sec, 819.25 docs/sec
```

Если выдает ошибку, то скорее всего информацию о том что не так можно найти в log/searchd.development.log.
Изучите конфиг SPHINX.conf на момент правильности данных для подключения к базе, sql_host, sql_password, sql_db.

Для генерации индексов без пересоздания конфига используйте:

```
INDEX_ONLY=true rake ts:index
```

### Запуск Проекта

- `rails s`

Победа, victoria!!!!

### License

Open Source Project under MIT License.
