# Copyright (c) 2022-2024 by Terry Greeniaus.
# Build with: docker build -t gcc-arm-none-eabi-13.3.rel1-nano_eh .
# Run with: docker run -ti --rm --mount type=bind,source="$(pwd)",target=/mnt/bind-root gcc-arm-none-eabi-13.3.rel1-nano_eh <cmd goes here>
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
ADD https://github.com/tgree/docker-gcc-arm-none-eabi-nano_eh-build/releases/download/v13.3.1/gcc-arm-none-eabi-13.3.rel1-nano-eh-src.tgz /tmp/
RUN mkdir /tmp/src/ \
 && tar x -C /tmp/src/ -f /tmp/gcc-arm-none-eabi-13.3.rel1-nano-eh-src.tgz \
 && mv /tmp/src/gcc /usr/src/ \
 && rm -rf /tmp/gcc-arm-none-eabi-13.3.rel1-nano-eh-src.tgz /tmp/src

# AMD64-specific bits.
FROM dev-base AS dev-base-linux_amd64
ADD https://github.com/tgree/docker-gcc-arm-none-eabi-nano_eh-build/releases/download/v13.3.1/gcc-arm-none-eabi-13.3.rel1-nano-eh-x86_64-linux.tar.xz /tmp/
RUN tar x -C /usr -f /tmp/gcc-arm-none-eabi-13.3.rel1-nano-eh-x86_64-linux.tar.xz \
    && rm /tmp/gcc-*

# ARM64-specific bits.
FROM dev-base AS dev-base-linux_arm64
ADD https://github.com/tgree/docker-gcc-arm-none-eabi-nano_eh-build/releases/download/v13.3.1/gcc-arm-none-eabi-13.3.rel1-nano-eh-aarch64-linux.tar.xz /tmp/
RUN tar x -C /usr -f /tmp/gcc-arm-none-eabi-13.3.rel1-nano-eh-aarch64-linux.tar.xz \
    && rm /tmp/gcc-*

# Select the proper arch for the rest of this.
FROM dev-base-${TARGETOS}_${TARGETARCH}

# Allow gdb to source .gdbinit file from /mnt/bind-root.
RUN echo "add-auto-load-safe-path /mnt/bind-root/.gdbinit" >> /root/.gdbinit
