# Copyright (c) 2022 by Terry Greeniaus.
# Build with: docker build -t gcc-arm-none-eabi-9.2.1 .
# Run with: docker run -ti --rm --mount type=bind,source="$(pwd)",target=/mnt/bind-root gcc-arm-none-eabi-9.2.1 <cmd goes here>
FROM ubuntu:20.04 AS dev-base

# Set the locale.
ENV LANG C.UTF-8

# Un-minimize to start with.
RUN yes | unminimize

# Install the standard tools we would like to export.
RUN apt-get update -y                                   \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y   \
    g++                                                 \
    gcc                                                 \
    gdb-multiarch                                       \
    git                                                 \
    make                                                \
    man                                                 \
    manpages                                            \
    manpages-dev

# Create the bind-mount directory.
RUN mkdir -p /mnt/bind-root
WORKDIR /mnt/bind-root

# Install the source in /usr/src and create a symlink to the gcc sources,
# to make it available for client use.
ADD https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-src.tar.bz2?revision=ed3827e2-edba-4f68-8f0f-ac647100866c&hash=8E80333E823CFEB3F99213221E4EF83B82FE224A \
    /tmp/gcc-arm-none-eabi-9-2019-q4-major-src.tar.bz2
RUN tar x -C /tmp/ -f /tmp/gcc-arm-none-eabi-9-2019-q4-major-src.tar.bz2 \
 && tar x -C /usr/src/ -f /tmp/gcc*/src/gcc.tar.bz2 \
 && rm -rf /tmp/gcc*

# AMD64-specific bits.
FROM dev-base AS dev-base-linux_amd64
ADD https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2?revision=108bd959-44bd-4619-9c19-26187abf5225&hash=46AF221F493505D04113CD7FD10F378688940FC8 \
    /tmp/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2
RUN tar xj -C /usr --strip 1 -f /tmp/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 \
 && rm /tmp/gcc-*

# ARM64-specific bits.
FROM dev-base AS dev-base-linux_arm64
ADD https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-aarch64-linux.tar.bz2?revision=4583ce78-e7e7-459a-ad9f-bff8e94839f1&hash=EE4BA674F815B508E1986A0B6790E4B329DCF1DC \
    /tmp/gcc-arm-none-eabi-9-2019-q4-major-aarch64-linux.tar.bz2
RUN tar xj -C /usr --strip 1 -f /tmp/gcc-arm-none-eabi-9-2019-q4-major-aarch64-linux.tar.bz2 \
 && rm /tmp/gcc-*

# Select the proper arch for the rest of this.
FROM dev-base-${TARGETOS}_${TARGETARCH}
