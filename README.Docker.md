## Docker Setup

## Проверка MySQL

Из корня проекта.

Запустить проект

```sh
cd docker
docker-compose up
```

Узнать имя контейнера с MySQL

```sh
docker ps
```

`docker-mysql-1`

```sh
docker exec -ti docker-mysql-1 /bin/bash
```

Зайти в MySQL

```sh
mysql -u root -pqwerty
```

```sql
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| opencook           |
| performance_schema |
| sys                |
+--------------------+
```

```sql
mysql> use mysql;
Database changed

mysql> SELECT user FROM user;
+------------------+
| user             |
+------------------+
| rails            |
| root             |
| mysql.infoschema |
| mysql.session    |
| mysql.sys        |
| root             |
+------------------+
```

## Загрузка дампа
