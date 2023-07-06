# For compatibility with Khmer Unicode (with Microsoft Office documents) only Alpine v3.11 is compatible.
ARG ALPINE_VERSION=3.11
FROM libreofficedocker/libreoffice-unoserver:${ALPINE_VERSION} AS base

FROM base AS lockrun
RUN apk add gcc musl-dev \
    ; cd /tmp \
    ; wget -O lockrun.c http://unixwiz.net/tools/lockrun.c \
    ; gcc lockrun.c -o lockrun

FROM base
ADD rootfs /
RUN set -xe \
    ; chmod +x /docker-cmd.sh \
    ; fc-cache -fv
CMD [ "/docker-cmd.sh" ]
COPY --from=lockrun /tmp/lockrun /usr/bin/lockrun
ENV UNOSERVER_CMD="unoserver --user-installation=/etc/libreoffice"
