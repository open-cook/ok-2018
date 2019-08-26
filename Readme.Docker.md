## Установка с помощью docker и docker-compose

**Потребуются**

- [Docker](https://docs.docker.com/get-started/)
- [Docker Compose](https://docs.docker.com/compose/)

**Проверить наличие**

```bash
$ docker -v
> Docker version 19.03.1

$ docker-compose -v
> docker-compose version 1.24.1
```

Как только они будут установленны, то необходимо будет настороить бд в database.yml, для работы с docker compose, a именно добавить строчку `host: postgres`

Теперь необходимо выполнить команду: `docker-compose build`
Если все прошло без ошибок, то можно смело запускать проект командой: `docker-compose up`

Чтобы восстановить дамп бд, необходимо будет выполнить команды:
- `docker cp Developer/open-cook.ru.rails_app_db.dump ok-2018_postgres_1:/`
- `docker exec ok-2018_postgres_1 pg_restore -U postgres -d open_cook_dev backups/open-cook.ru.rails_app_db.dump`

Также надо не забыть настроить sphinxsearch для поиска! Для этого необходимо выполнить следующие команды:

- `docker exec ok-2018_web_1 rake ts:configure ts:restart`
- `docker exec ok-2018_web_1 rake ts:index`
