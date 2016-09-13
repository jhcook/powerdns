FROM rhel7/rhel

MAINTAINER Justin Cook <jhcook@gmail.com>

USER root

RUN curl -o /etc/yum.repos.d/powerdns-auth-40.repo \
    https://repo.powerdns.com/repo-files/centos-auth-40.repo && \
    yum -y --setopt=tsflags='' install pdns pdns-backend-sqlite bind-utils && \
    yum clean all

RUN mkdir /var/run/pdns && chown 1001:0 /var/run/pdns && \
    chmod -R g+rw /var/run/pdns && mkdir /etc/pdns/zones && \
    sqlite3 /etc/pdns/zones/pdns.sqlite3 < \
    /usr/share/doc/pdns-backend-sqlite-4.0.1/schema.sqlite3.sql && \
    chown -R 1001:0 /etc/pdns && chmod -R g+rw /etc/pdns

ARG role=master
ENV ROLE ${role}

COPY ${ROLE}/pdns.conf /etc/pdns/
COPY startup.sh /

USER 1001

EXPOSE 5353/tcp
EXPOSE 5353/udp

CMD ["/startup.sh"]
