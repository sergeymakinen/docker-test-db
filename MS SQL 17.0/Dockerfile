FROM microsoft/mssql-server-linux:ctp-2.0

LABEL maintainer "sergey@makinen.ru"

ENV MSSQL_USER docker
ENV MSSQL_PASSWORD docker
ENV MSSQL_DB docker
ENV ACCEPT_EULA y
ENV SA_PASSWORD dockerPassword0
ENV PATH $PATH:/opt/mssql-tools/bin

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
