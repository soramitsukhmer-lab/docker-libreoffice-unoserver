## About

The LibreOffice with unoserver on Docker

## Features

- Include a sets of Khmer Unicode fonts such as `kantumruy`, `kdamthmor`, `khmer`, `khmeros` and `khmeros-crosextra`. You can add more fonts to this directory `rootfs/usr/share/fonts/truetype`.
- Include a custom version of `unoserver` from [socheatsok78-lab/unoserver](https://github.com/socheatsok78-lab/unoserver).

### Usage

This image uses the [`alpine`](https://hub.docker.com/_/alpine) as base images.

```
docker pull soramitsukhmer-lab/libreoffice-unoserver:latest
```

### REST API

This image shipped with REST API for unoserver by default.

See https://github.com/libreoffice-docker/unoserver-rest-api for more information.

> **⚠️ Caution ⚠️**
>
> It is important to know that the  REST API layer DOES NOT provide any type of security whatsoever.
> It is NOT RECOMMENDED to expose this container image to the internet.

## License

Licensed under [Apache-2.0 license](LICENSE)
