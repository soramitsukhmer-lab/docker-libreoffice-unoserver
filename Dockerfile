# For compatibility with Khmer Unicode (with Microsoft Office documents) only Alpine v3.11 is compatible.
ARG ALPINE_VERSION=3.11
FROM libreofficedocker/libreoffice-unoserver:${ALPINE_VERSION}

ADD rootfs /
RUN set -xe \
    ; chmod +x /docker-cmd.sh \
    ; fc-cache -fv

ENV UNOSERVER_CMD="unoserver --user-installation=/etc/libreoffice"
