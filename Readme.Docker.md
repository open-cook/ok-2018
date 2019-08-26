## Установка с помощью docker и docker-compose

**1. Необходимое ПО**

- [Docker](https://docs.docker.com/get-started/)
- [Docker Compose](https://docs.docker.com/compose/)

*Проверить наличие*

```bash
$ docker -v
> Docker version 19.03.1

$ docker-compose -v
> docker-compose version 1.24.1
```

**2. Скопируйте конфигурационные файлы**

- `cp -R config/config.examples/ENV/ config/ENV`
- `cp config/config.examples/database.yml config/database.yml`

**3. Запустить команду для поднятия окружения**

- `docker-compose --verbose build`

**4. Архив данных для разработки**

- Получите архив данных для разработки `obfuscated_data.tar.gz` (Смотри: [data_obfuscation.rake](lib/tasks/README.md))
- Поместите архив к каталог `./tmp`
- Распакуйте архив
    ```
    mkdir -p ./tmp/untar

    tar xvzf ./tmp/obfuscated_data.tar.gz -C ./tmp/untar
    ```

**5. Скопируйте фалйы в каталог ./public**

**6. Загрузите Базу Данных**

`Не проверено`

- `docker cp Developer/open-cook.ru.rails_app_db.dump ok-2018_postgres_1:/`
- `docker exec ok-2018_postgres_1 pg_restore -U postgres -d open_cook_dev backups/open-cook.ru.rails_app_db.dump`

**7. Проиндексируйте данные для Поиска**

`Не проверено`

- `docker exec ok-2018_web_1 rake ts:configure ts:restart`
- `docker exec ok-2018_web_1 rake ts:index`

**8. Запустите проект**

- `docker-compose up`

**9. Доступ в Rails console**

`Не проверено`

**10. Выполение rake tasks и других команд в контейнере**

`Не проверено`
