FROM fluent/fluentd:1.4
MAINTAINER saggiyogesh@gmail.com
WORKDIR /home/fluent
ENV PATH /home/fluent/.gem/ruby/2.4.0/bin:$PATH
ENV APK_ADD=".build-deps sudo build-base ruby-dev"
ENV APK_DEL=".build-deps sudo build-base ruby-dev"

ARG GEM_VERSION="-v 1.1.4"
ARG GEM_NAME="fluent-plugin-s3"
RUN apk add --update --no-cache --virtual $APK_ADD && \
      sudo gem install fluent-plugin-s3 -v 1.1.10 && \
      sudo gem install fluent-plugin-record-modifier -v 2.0.1 && \
      sudo gem install fluent-plugin-gelf-hs -v 1.0.8 && \
      sudo gem sources --clear-all && \
      apk del ${APK_DEL} && rm -rf /var/cache/apk/* \
        /home/fluent/.gem/ruby/2.4.0/cache/*.gem

RUN deluser --remove-home postmaster
RUN deluser --remove-home cyrus
RUN deluser --remove-home mail
RUN deluser --remove-home news
RUN deluser --remove-home uucp
RUN deluser --remove-home operator
RUN deluser --remove-home man
RUN deluser --remove-home cron
RUN deluser --remove-home ftp
RUN deluser --remove-home sshd
RUN deluser --remove-home at
RUN deluser --remove-home squid
RUN deluser --remove-home xfs
RUN deluser --remove-home games
RUN deluser --remove-home postgres
RUN deluser --remove-home vpopmail
RUN deluser --remove-home ntp
RUN deluser --remove-home smmsp
RUN deluser --remove-home guest

COPY ./scripts/version-info /usr/bin
EXPOSE 24224

ENTRYPOINT exec fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins
