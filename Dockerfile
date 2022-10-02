FROM alpine:3.11

# BuildFS
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
ADD buildfs /
RUN set -xe \
    ; apk update \
    ; apk add --no-cache --purge -uU \
        bash curl tzdata \
        freetype freetype-dev \
        icu icu-libs \
        musl musl-dev musl-libintl libc6-compat \
    ; rm -rf /var/cache/apk/* /tmp/*


# OpenJDK JRE
ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"
RUN set -xe \
    ; apk update \
    ; apk add --no-cache --purge -uU \
        openjdk11-jre \
        openjdk11-jre-headless \
    ; rm -rf /var/cache/apk/* /tmp/*


# Microsoft TrueType core fonts
RUN set -xe \
    ; apk update \
    ; apk add --no-cache --purge -uU \
        ttf-dejavu \
        msttcorefonts-installer \
    ; rm -rf /var/cache/apk/* /tmp/* \
    ; update-ms-fonts


# LibreOffice
RUN set -xe \
    ; apk update \
    ; apk add --no-cache --purge -uU libreoffice \
    ; rm -rf /var/cache/apk/* /tmp/*
    # ; apk search -qe 'libreoffice-lang-*' | xargs apk add --no-cache --purge -uU \

ENV URE_BOOTSTRAP "vnd.sun.star.pathname:/usr/lib/libreoffice/program/fundamentalrc"
ENV PATH "/usr/lib/libreoffice/program:$PATH"
ENV UNO_PATH "/usr/lib/libreoffice/program"
ENV LD_LIBRARY_PATH "/usr/lib/libreoffice/program:/usr/lib/libreoffice/ure/lib:$LD_LIBRARY_PATH"
ENV PYTHONPATH "/usr/lib/libreoffice/program:$PYTHONPATH"


# Python PIP
ENV PYTHONUNBUFFERED=1
RUN python3 --version \
    ; ln -s /usr/bin/python3 /usr/bin/python \
    ; python3 -m ensurepip \
    ; pip3 install --no-cache --upgrade pip

RUN pip install --no-cache unoserver


# Unoserver REST Api
ARG UNOSERVER_REST_API_VERSION=0.2.0
ADD https://github.com/libreoffice-docker/unoserver-rest-api/releases/download/v${UNOSERVER_REST_API_VERSION}/unoserver-rest-api-linux /usr/bin/unoserver-rest-api
RUN chmod +x /usr/bin/unoserver-rest-api
ADD https://github.com/libreoffice-docker/unoserver-rest-api/releases/download/v${UNOSERVER_REST_API_VERSION}/s6-overlay-module.tar.zx /tmp
ADD https://github.com/libreoffice-docker/unoserver-rest-api/releases/download/v${UNOSERVER_REST_API_VERSION}/s6-overlay-module.tar.zx.sha256 /tmp
RUN cd /tmp \
    && sha256sum -c *.sha256 \
    && tar -C / -Jxpf /tmp/s6-overlay-module.tar.zx \
    && rm -rf /tmp/*.tar*
EXPOSE 2004
ENV UNOSERVER_CMD="unoserver --user-installation=/etc/libreoffice"


# s6-overlay
ARG S6_OVERLAY_VERSION=3.1.1.2
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz.sha256 /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz.sha256 /tmp
RUN cd /tmp && sha256sum -c *.sha256 && \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz && \
    rm -rf /tmp/*.tar*
ENTRYPOINT ["/init"]


# RootFS
ADD rootfs /
RUN set -xe \
    ; chmod +x /docker-cmd.sh \
    ; fc-cache -fv
CMD [ "/docker-cmd.sh" ]
