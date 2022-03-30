# Copyright (c) 2022 by Terry Greeniaus.
# Build with: docker build -t gcc-arm-none-eabi-10.3.1 .
# Run with: docker run -ti --rm --mount type=bind,source="$(pwd)",target=/mnt/bind-root gcc-arm-none-eabi-10.3.1 <cmd goes here>
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
ADD https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-src.tar.bz2 /tmp/
RUN tar x -C /tmp/ -f /tmp/gcc-arm-none-eabi-10.3-2021.10-src.tar.bz2 \
 && tar x -C /usr/src/ -f /tmp/gcc*/src/gcc.tar.bz2 \
 && rm -rf /tmp/gcc*

# AMD64-specific bits.
FROM dev-base AS dev-base-linux_amd64
ADD https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 /tmp/
RUN tar xj -C /usr --strip 1 -f /tmp/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 \
 && rm /tmp/gcc-*

# ARM64-specific bits.
FROM dev-base AS dev-base-linux_arm64
ADD https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-aarch64-linux.tar.bz2 /tmp/
RUN tar xj -C /usr --strip 1 -f /tmp/gcc-arm-none-eabi-10.3-2021.10-aarch64-linux.tar.bz2 \
 && rm /tmp/gcc-*

# Select the proper arch for the rest of this.
FROM dev-base-${TARGETOS}_${TARGETARCH}

# Allow gdb to source .gdbinit file from /mnt/bind-root.
RUN echo "add-auto-load-safe-path /mnt/bind-root/.gdbinit" >> /root/.gdbinit
