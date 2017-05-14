FROM ubuntu:16.04

LABEL maintainer "sergey@makinen.ru"

ENV DEBIAN_FRONTEND noninteractive

ENV GOSU_VERSION 1.10
RUN apt-get update && apt-get install -y curl \
    && curl -L https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64 -o /usr/local/bin/gosu \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && rm -rf /var/lib/apt/lists/* && apt-get purge -y --auto-remove curl

ENV MYSQL_MAJOR 5.1
ENV MYSQL_VERSION 5.1.71
ENV MYSQL_GLIBC_VERSION 23
ENV MYSQL /usr/local/mysql
ENV MYSQL_DATABASES /var/lib/mysql
ENV MYSQL_USER docker
ENV MYSQL_PASSWORD docker
ENV MYSQL_DB docker
ENV PATH $PATH:$MYSQL/sbin:$MYSQL/bin

RUN groupadd -r mysql && useradd -r -g mysql mysql \
    && apt-get update && apt-get install -y curl rpm2cpio cpio \
    && mkdir $MYSQL && TMP_DIR="$(mktemp -d)" && cd "$TMP_DIR" \
    && curl -L https://downloads.mysql.com/archives/get/file/MySQL-server-$MYSQL_VERSION-1.glibc$MYSQL_GLIBC_VERSION.x86_64.rpm -o server.rpm \
    && rpm2cpio server.rpm | cpio -i -d -v && cp -r usr/* $MYSQL && rm -rf ./* \
    && curl -L https://downloads.mysql.com/archives/get/file/MySQL-client-$MYSQL_VERSION-1.glibc$MYSQL_GLIBC_VERSION.x86_64.rpm -o client.rpm \
    && rpm2cpio client.rpm | cpio -i -d -v && cp -r usr/* $MYSQL && rm -rf "$TMP_DIR" \
    && mkdir -p $MYSQL_DATABASES \
    && chown -R mysql:mysql $MYSQL $MYSQL_DATABASES \
    && rm -rf /var/lib/apt/lists/* && apt-get purge -y --auto-remove curl rpm2cpio cpio
    
VOLUME $MYSQL_DATABASES

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
