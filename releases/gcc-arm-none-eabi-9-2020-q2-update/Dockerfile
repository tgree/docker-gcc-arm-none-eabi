# Copyright (c) 2022 by Terry Greeniaus.
# Build with: docker build -t gcc-arm-none-eabi-9.3.1 .
# Run with: docker run -ti --rm --mount type=bind,source="$(pwd)",target=/mnt/bind-root gcc-arm-none-eabi-9.3.1 <cmd goes here>
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
    manpages-dev                                        \
    python3

# Create the bind-mount directory.
RUN mkdir -p /mnt/bind-root
WORKDIR /mnt/bind-root

# Install the source in /usr/src and create a symlink to the gcc sources,
# to make it available for client use.
ADD https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-src.tar.bz2?revision=e2232c7c-4893-46b6-b791-356bdc29fd7f&hash=3F69123275AC9145DC182AD8B283E1F591AEF5A3 \
    /tmp/gcc-arm-none-eabi-9-2020-q2-update-src.tar.bz2
RUN tar x -C /tmp/ -f /tmp/gcc-arm-none-eabi-9-2020-q2-update-src.tar.bz2 \
 && tar x -C /usr/src/ -f /tmp/gcc*/src/gcc.tar.bz2 \
 && rm -rf /tmp/gcc*

# AMD64-specific bits.
FROM dev-base AS dev-base-linux_amd64
ADD https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2?revision=05382cca-1721-44e1-ae19-1e7c3dc96118&hash=CEB1348BF26C0285FD788E2424773FA304921735 \
    /tmp/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2
RUN tar xj -C /usr --strip 1 -f /tmp/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 \
 && rm /tmp/gcc-*

# ARM64-specific bits.
FROM dev-base AS dev-base-linux_arm64
ADD https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-aarch64-linux.tar.bz2?revision=7166404a-b4f5-4598-ac75-e5f8b90abb09&hash=677A37572111E71B45A8B287789549356B0E4E71 \
    /tmp/gcc-arm-none-eabi-9-2020-q2-update-aarch64-linux.tar.bz2
RUN tar xj -C /usr --strip 1 -f /tmp/gcc-arm-none-eabi-9-2020-q2-update-aarch64-linux.tar.bz2 \
 && rm /tmp/gcc-*

# Select the proper arch for the rest of this.
FROM dev-base-${TARGETOS}_${TARGETARCH}

# Allow gdb to source .gdbinit file from /mnt/bind-root.
RUN echo "add-auto-load-safe-path /mnt/bind-root/.gdbinit" >> /root/.gdbinit
