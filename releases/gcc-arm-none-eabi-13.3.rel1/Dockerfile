# Copyright (c) 2022-2024 by Terry Greeniaus.
# Build with: docker build -t gcc-arm-none-eabi-13.3.rel1 .
# Run with: docker run -ti --rm --mount type=bind,source="$(pwd)",target=/mnt/bind-root gcc-arm-none-eabi-13.3.rel1 <cmd goes here>
FROM ubuntu:24.04 AS dev-base

# Set the locale.
ENV LANG C.UTF-8

# Un-minimize to start with.
RUN yes | unminimize

# Install the standard tools we would like to export.
RUN apt-get update -y                                   \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y   \
    bzip2                                               \
    g++                                                 \
    gcc                                                 \
    gdb-multiarch                                       \
    git                                                 \
    make                                                \
    man                                                 \
    manpages                                            \
    manpages-dev                                        \
    python3                                             \
    xz-utils

# Create the bind-mount directory.
RUN mkdir -p /mnt/bind-root
WORKDIR /mnt/bind-root

# Install the source in /usr/src and create a symlink to the gcc sources,
# to make it available for client use.
ADD https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/srcrel/arm-gnu-toolchain-src-snapshot-13.3.rel1.tar.xz /tmp/
RUN mkdir /tmp/src/ \
 && tar x -C /tmp/src/ -f /tmp/arm-gnu-toolchain-src-snapshot-13.3.rel1.tar.xz \
 && mv /tmp/src/gcc /usr/src/ \
 && rm -rf /tmp/arm-gnu-toolchain-src-snapshot-13.3.rel1.tar.xz /tmp/src

# AMD64-specific bits.
FROM dev-base AS dev-base-linux_amd64
ADD https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz /tmp/
RUN tar x -C /usr --strip 1 -f /tmp/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz \
    && rm /tmp/arm-*

# ARM64-specific bits.
FROM dev-base AS dev-base-linux_arm64
ADD https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-aarch64-arm-none-eabi.tar.xz /tmp/
RUN tar x -C /usr --strip 1 -f /tmp/arm-gnu-toolchain-13.3.rel1-aarch64-arm-none-eabi.tar.xz \
    && rm /tmp/arm-*

# Select the proper arch for the rest of this.
FROM dev-base-${TARGETOS}_${TARGETARCH}

# Allow gdb to source .gdbinit file from /mnt/bind-root.
RUN echo "add-auto-load-safe-path /mnt/bind-root/.gdbinit" >> /root/.gdbinit
