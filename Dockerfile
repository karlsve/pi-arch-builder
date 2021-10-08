FROM debian:stable-slim

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

# Setup build system
## Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends qemu qemu-user-static binfmt-support kpartx qemu-utils parted e2fsprogs
RUN apt-get clean

# Setup builder directory
RUN mkdir /builder && mkdir /builder/mnt
COPY ./entrypoint.sh /builder/entrypoint.sh
RUN chmod +x /builder/entrypoint.sh

VOLUME /builder/images

WORKDIR /builder
ENTRYPOINT [ "./entrypoint.sh" ]