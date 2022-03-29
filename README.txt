docker-gcc-arm-none-eabi

This repository provides simple Dockerfiles that generate containers
containing the standard and nano_eh versions of gcc-arm-none-eabi.  By building
the container and bind-mounting a host source code directory you can easily use
the gcc-arm-none-eabi tools to build your code instead of having to install
custom tools on your Mac (or, presumably, Windows) box.  Furthermore, you can
easily have multiple versions of gcc installed in separate containers without
worrying about them conflicting with one another.

Building the containers is simple:

    ./build_containers.sh

This will build each of the gcc versions listed in the versions/ directory.
The versions are canonical gcc versions such as "9.3.1" and the versions/
directory maps them to ARM release names in the releases/ directory.  The only
caveat when building is that the ARM host servers are slow and flaky and
frequently drop the connection when downloading compiler tarballs; you may
need to try running the script multiple times if this happens to you.

With the built containers, via Docker you can now run standard
gcc-arm-none-eabi and Linux commands such as make or arm-none-eabi-gcc, etc.
First, change to your source directory that you wish to build and then use the
following unwieldy syntax:

    docker run -ti --rm \
        --mount type=bind,source="$(pwd)",target=/mnt/bind-root \
        gcc-arm-none-eabi-10.3.1 <CMD_GOES_HERE>

Replace <CMD_GOES_HERE> with the command you wish to execute (typically make).
It is highly recommended to create aliases in your shell profile or rc script,
similar to:

    alias gcc-arm-none-eabi-10.3.1='docker run -ti --rm --mount type=bind,source="$(pwd)",target=/mnt/bind-root gcc-arm-none-eabi-10.3.1'

With the aliases in place, you can build your make-driven repository:

    gcc-arm-none-eabi-10.3.1 make

And, of course, you can pass arguments like you normally would:

    gcc-arm-none-eabi-10.3.1 make -j unittests

Since there are multiple containers built with a different compiler in each,
you may wish to create multiple aliases; the aliases.txt file generated during
the build process contains aliases for all generated compilers.

The Dockerfile installs a number of different tools inside each container:

    arm-none-eabi-*
    g++
    gcc
    gdb-multiarch
    git
    make
    man

The g++/gcc tools are installed so that you can build and run native (non-ARM)
tools alongside arm-none-eabi-gcc targets.  This could be used to build and
execute unittests as part of your normal build process, for instance.

The gdb-multiarch tool is installed to allow you to debug your binary,
typically by remote-connecting to a GDB server.  Since gdb-multiarch runs from
inside the container, you will need to execute a command similar to the
following to connect to a GDB server running on the host:

    target remote host.docker.internal:<port number>

The git tool is installed to allow you to perform repository introspection as
part of your make process (perhaps you want to embed the current git SHA1 in
your target binary); you could also use it to do standard git operations on
your repo if desired but you probably already have git installed on your host
anyways.

The make tool is installed for obvious reasons and is the main tool you will
probably be using.  The Dockerfiles could probably easily be extended to
support other build systems such as CMake by changing which apt packages get
installed.

The man pages are there for reference since you may not be on a Linux host and
therefore not have handy man pages available.

Finally, at any time you can simply drop into an instance of the container
using the bash command and poke around to see what is going on:

    gcc-arm-none-eabi-10.3.1 bash

The compile performance on Docker for Mac with bind-mounts can be quite good,
however the latest versions of Docker and macOS are required.  With Docker
4.6.1 and the experimental VirtioFS support enabled the build time using bind
mounts is similar to the build time when all sources are included directly in
the container instead.  Other platforms have not been tested.
