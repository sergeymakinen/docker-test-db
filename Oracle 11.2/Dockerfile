FROM ubuntu:16.04

LABEL maintainer "sergey@makinen.ru"

ENV DEBIAN_FRONTEND noninteractive

ENV GOSU_VERSION 1.10
RUN apt-get update && apt-get install -y curl \
    && curl -L https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64 -o /usr/local/bin/gosu \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
    && rm -rf /var/lib/apt/lists/* && apt-get purge -y --auto-remove curl

ENV ORACLE_MAJOR 11.2
ENV ORACLE_VERSION 11.2.0.1.0
ENV ORACLE_PRODUCT /usr/local/oracle
ENV ORACLE_BASE /u01/app/oracle
ENV ORACLE_HOME $ORACLE_BASE/product/11.2.0/xe
ENV ORACLE_USER docker
ENV ORACLE_PASSWORD docker
ENV ORACLE_DB docker
ENV ORACLE_SID=XE
ENV PATH $PATH:$ORACLE_HOME/bin
ENV AWK /usr/bin/awk

RUN apt-get update && apt-get install -y bc libaio1 net-tools \
        curl alien \
    && TMP_DIR="$(mktemp -d)" && cd "$TMP_DIR" \
    && for part in $(seq 1 7); do echo "Downloading part $part of 7" && curl -L https://github.com/sergeymakinen/docker-test-db/raw/assets/oracle-xe-11.2.0-1.0.x86_64.rpm.$part -o server.rpm.$part; done \
    && cat server.rpm.* > server.rpm && alien -c -i -k -v server.rpm \
    && mkdir -p $ORACLE_PRODUCT /var/lock/subsys && mv $ORACLE_HOME/* $ORACLE_PRODUCT && rm -rf "$TMP_DIR" $ORACLE_BASE/* $ORACLE_PRODUCT/dbs \
    && rm -rf /var/lib/apt/lists/* && apt-get purge -y --auto-remove curl alien
    
RUN config="COMMIT_WAIT = NOWAIT\nCOMMIT_LOGGING = BATCH\nDISK_ASYNCH_IO = FALSE\nFILESYSTEMIO_OPTIONS = NONE" \
    && echo "$config" >> $ORACLE_PRODUCT/config/scripts/init.ora \
    && echo "$config" >> $ORACLE_PRODUCT/config/scripts/initXETemp.ora \
    && sed -i -E 's#memory_target=[^\n]+#memory_target=536870912#' $ORACLE_PRODUCT/config/scripts/init.ora \
    && sed -i -E 's#memory_target=[^\n]+#memory_target=536870912#' $ORACLE_PRODUCT/config/scripts/initXETemp.ora \
    && sed -i -E 's#HOST = [^)]+#HOST = 0.0.0.0#' $ORACLE_PRODUCT/network/admin/listener.ora \
    && sed -i -E 's#PORT = [^)]+#PORT = 1521#' $ORACLE_PRODUCT/network/admin/listener.ora \
    && echo 'DIAG_ADR_ENABLED = OFF' >> $ORACLE_PRODUCT/network/admin/listener.ora \
    && echo "export ORACLE_HOME=$ORACLE_HOME\nexport PATH=$PATH\nexport ORACLE_SID=$ORACLE_SID" > /etc/profile.d/oracle-xe.sh \
    && echo '#!/bin/bash' > /sbin/chkconfig && chmod +x /sbin/chkconfig \
    && chown -R oracle:dba $ORACLE_PRODUCT

VOLUME $ORACLE_BASE

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 1521
