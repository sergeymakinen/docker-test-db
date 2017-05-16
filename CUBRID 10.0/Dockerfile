FROM ubuntu:16.04

LABEL maintainer "sergey@makinen.ru"

ENV DEBIAN_FRONTEND noninteractive

ENV GOSU_VERSION 1.10
RUN apt-get update && apt-get install -y curl \
    && curl -L https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64 -o /usr/local/bin/gosu \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && rm -rf /var/lib/apt/lists/* && apt-get purge -y --auto-remove curl

ENV CUBRID_MAJOR 10.0
ENV CUBRID_VERSION 10.0.0.1376
ENV CUBRID /usr/local/cubrid
ENV CUBRID_DATABASES /var/lib/cubrid
ENV CUBRID_USER docker
ENV CUBRID_PASSWORD docker
ENV CUBRID_DB docker
ENV CUBRID_VOLUME_SIZE 256M
ENV CUBRID_LOCALE en_US
ENV PATH $PATH:$CUBRID/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$CUBRID/lib

RUN groupadd -r cubrid && useradd -r -g cubrid cubrid \
    && apt-get update && apt-get install -y curl \
    && curl -L http://ftp.cubrid.org/CUBRID_Engine/$CUBRID_MAJOR/CUBRID-$CUBRID_VERSION-linux.x86_64.tar.gz -o cubrid.tar.gz \
    && mkdir $CUBRID && tar -xzf cubrid.tar.gz -C $CUBRID --strip-components=1 && rm cubrid.tar.gz \
    && mkdir -p $CUBRID_DATABASES \
    && chown -R cubrid:cubrid $CUBRID $CUBRID_DATABASES \
    && rm -rf /var/lib/apt/lists/* && apt-get purge -y --auto-remove curl

VOLUME $CUBRID_DATABASES

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 33000
