FROM adoptopenjdk/openjdk11:jre-11.0.6_10-alpine

# Default to UTF-8 file.encoding
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN set -xe \
    ; apk update \
    ; apk add --no-cache --purge -uU \
        bash curl \
    ; rm -rf /var/cache/apk/* /tmp/*


# Library for configuring and customizing font access
RUN set -xe \
    ; apk update \
    ; apk add --no-cache --purge -uU \
        fontconfig \
        encodings \
        mkfontdir \
        mkfontscale \
    ; rm -rf /var/cache/apk/* /tmp/*


# Microsoft TrueType core fonts
RUN set -xe \
    ; apk update \
    ; apk add --no-cache --purge -uU \
        msttcorefonts-installer \
    ; rm -rf /var/cache/apk/* /tmp/* \
    ; update-ms-fonts


# LibreOffice
RUN set -xe \
    ; apk update \
    ; apk add --no-cache --purge -uU libreoffice \
    ; rm -rf /var/cache/apk/* /tmp/*

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
    ; pip3 install --no-cache --upgrade pip setuptools

RUN pip install --no-cache unoserver


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


# Unoserver REST Api
ARG UNOSERVER_REST_API_VERSION=0.2.0
ADD https://github.com/libreoffice-docker/unoserver-rest-api/releases/download/v${UNOSERVER_REST_API_VERSION}/unoserver-rest-api-linux /usr/bin/unoserver-rest-api
RUN chmod +x /usr/bin/unoserver-rest-api
ADD https://github.com/libreoffice-docker/unoserver-rest-api/releases/download/v${UNOSERVER_REST_API_VERSION}/s6-overlay-module.tar.zx /tmp
ADD https://github.com/libreoffice-docker/unoserver-rest-api/releases/download/v${UNOSERVER_REST_API_VERSION}/s6-overlay-module.tar.zx.sha256 /tmp
RUN cd /tmp && sha256sum -c *.sha256 && \
    tar -C / -Jxpf /tmp/s6-overlay-module.tar.zx && \
    rm -rf /tmp/*.tar*
EXPOSE 2004
ENV UNOSERVER_CMD="unoserver --user-installation=/etc/libreoffice"


# RootFS
ADD rootfs /
RUN fc-cache -fv \
    ; chmod +x /docker-cmd.sh
ONBUILD RUN fc-cache -fv
CMD [ "/docker-cmd.sh" ]
