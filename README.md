# Test Database Dockerfiles

This repository contains **Dockerfiles** of various SQL DBMSes optimized for testing for [Docker](https://www.docker.com/)'s [automated build](https://hub.docker.com/r/sergeymakinen/oracle/) published to [Docker Hub](https://hub.docker.com/).

[![Build Type](https://img.shields.io/docker/automated/sergeymakinen/test-db.svg?style=flat-square)](https://hub.docker.com/r/sergeymakinen/test-db/) [![Total Stars](https://img.shields.io/docker/stars/sergeymakinen/test-db.svg?style=flat-square)](https://hub.docker.com/r/sergeymakinen/test-db/) [![Total Pulls](https://img.shields.io/docker/pulls/sergeymakinen/test-db.svg?style=flat-square)](https://hub.docker.com/r/sergeymakinen/test-db/) [![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](LICENSE)

## Supported tags and respective `Dockerfile` links

* `cubrid-9.3` [(CUBRID 9.3/Dockerfile)](CUBRID%209.3/Dockerfile)
* `mssql-17.0` [(MS SQL 17.0/Dockerfile)](MS%20SQL%2017.0/Dockerfile)
* `mysql-5.0` [(MySQL 5.0/Dockerfile)](MySQL%205.0/Dockerfile)
* `mysql-5.1` [(MySQL 5.1/Dockerfile)](MySQL%205.1/Dockerfile)
* `oracle-11.2` [(Oracle 11.2/Dockerfile)](Oracle%2011.2/Dockerfile)
* `postgresql-9.3` [(PostgreSQL 9.3/Dockerfile)](PostgreSQL%209.3/Dockerfile)

## Installation

1. Install [Docker](https://www.docker.com/).

2. Download [automated build](https://hub.docker.com/r/sergeymakinen/test-db/) from [Docker Hub](https://hub.docker.com/): 

```bash
docker pull sergeymakinen/test-db:tag
```

## How to use the CUBRID image

#### Start an instance

```bash
docker run --name some-cubrid -p 33000:33000 -d sergeymakinen/test-db:cubrid-9.3
```

#### Start with persistent storage

```bash
docker run --name some-cubrid -p 33000:33000 -t ./data:/var/lib/cubrid -d sergeymakinen/test-db:cubrid-9.3
```

#### Connect to it

Parameter | Value | Environment variable
--- | --- | ---
Host | `localhost` |
Port | `33000 ` |
User ID | `docker` | `$CUBRID_USER`
Password | `docker` | `$CUBRID_PASSWORD`
Database | `docker` | `$CUBRID_DB`

## How to use the MS SQL image

#### Start an instance

```bash
docker run --name some-mssql -p 1433:1433 -d sergeymakinen/test-db:mssql-17.0
```

#### Connect to it

Parameter | Value | Environment variable
--- | --- | ---
Host | `localhost` |
Port | `1433` |
User ID | `docker` | `$MSSQL_USER`
Password | `docker` | `$MSSQL_PASSWORD`
Database | `docker` | `$MSSQL_DB`

## How to use the MySQL image

#### Start an instance

```bash
docker run --name some-mysql -p 3306:3306 -d sergeymakinen/test-db:mysql-5.1
```

#### Start with persistent storage

```bash
docker run --name some-mysql -p 3306:3306 -t ./data:/var/lib/mysql -d sergeymakinen/test-db:mysql-5.1
```

#### Connect to it

Parameter | Value | Environment variable
--- | --- | ---
Host | `localhost` |
Port | `3306` |
User ID | `docker` | `$MYSQL_USER`
Password | `docker` | `$MYSQL_PASSWORD`
Database | `docker` | `$MYSQL_DB`

## How to use the Oracle image

#### Start an instance

```bash
docker run --name some-oracle -p 1521:1521 -d sergeymakinen/test-db:oracle-11.2
```

#### Start with persistent storage

```bash
docker run --name some-oracle -p 1521:1521 -t ./data:/u01/app/oracle -d sergeymakinen/test-db:oracle-11.2
```

#### Connect to it

Parameter | Value | Environment variable
--- | --- | ---
Host | `localhost` |
Port | `1521` |
SID | `xe` |
User ID | `docker` | `$ORACLE_USER`
Password | `docker` | `$ORACLE_PASSWORD`
Schema | `docker` | `$ORACLE_DB`

## How to use the PostgreSQL image

#### Start an instance

```bash
docker run --name some-postgresql -p 5432:5432 -d sergeymakinen/test-db:postgresql-9.3
```

#### Start with persistent storage

```bash
docker run --name some-postgresql -p 5432:5432 -t ./data:/var/lib/postgresql/data -d sergeymakinen/test-db:postgresql-9.3
```

#### Connect to it

Parameter | Value | Environment variable
--- | --- | ---
Host | `localhost` |
Port | `5432` |
User ID | `docker` | `$POSTGRES_USER`
Password | `docker` | `$POSTGRES_PASSWORD`
Database | `docker` | `$POSTGRES_DB`
