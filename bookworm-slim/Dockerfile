# Dockerfile for Debian with Russian locales and Moscow timezone
FROM debian:bookworm-slim
LABEL maintainer="Vladimir Tananko <v.tananko@gmail.com>"

ARG BUILD_DATE

# Labels
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.description="Debian with Russian locales and Moscow timezone"
LABEL org.label-schema.name="debian-ru/bookworm-slim"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.vcs-url="https://github.com/vtananko/debian-ru/bookworm-slim"
LABEL org.label-schema.vendor="BS-Lab"


ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

RUN sed -i -re "s/(http:\/\/)deb/\1ftp.ru/" /etc/apt/sources.list.d/debian.sources \
    && echo "deb http://ftp.ru.debian.org/debian bookworm-backports main" > /etc/apt/sources.list.d/backports.list \
    && apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends locales \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=ru_RU.UTF-8
ENV LC_MESSAGES=C.UTF-8

# vim:set ft=dockerfile:
