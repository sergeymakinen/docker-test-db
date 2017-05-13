FROM postgres:9.3

LABEL maintainer "sergey@makinen.ru"

ENV POSTGRES_USER docker
ENV POSTGRES_PASSWORD docker
ENV POSTGRES_DB docker

RUN echo "synchronous_commit = off\nfsync = off\nfull_page_writes = off" >> /usr/share/postgresql/postgresql.conf.sample
