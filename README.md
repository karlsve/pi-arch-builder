# pi-arch-builder
Helps finishing builds for specific archs.

## How to use

```sh
# docker build -t <tag> .
# docker run -it -v path/to/images:/builder/images --privileged --rm <tag> <image-name>.img targetArch [optional size increment in form '3G' or '500M']
docker build -t pi-builder .
docker run -it -v $(pwd)/images:/builder/images --privileged --rm pi-builder ubuntu.img aarch64 3G
```

Once started you will be dropped into a shell on the image running within qemu to emulate the correct environment.
