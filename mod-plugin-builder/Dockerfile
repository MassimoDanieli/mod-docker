# Use multi-stage builds
FROM mod-host as builder

ENV REBUILD=true
ENV DEBIAN_FRONTEND=noninteractive
ENV WORKDIR /mod/mod-plugin-builder/mod-workdir

# Install dependencies
RUN apt-get update && apt-get install -q -y --no-install-recommends acl bc curl cvs git mercurial \
        rsync subversion wget bison bzip2 flex gawk gperf gzip help2man nano \
        perl patch tar texinfo unzip automake binutils build-essential cpio \
        libtool libncurses-dev pkg-config python-is-python3 libtool-bin premake bundler \
    && rm -rf /var/lib/apt/lists/*

# Clone mod-plugin-builder
RUN git clone https://github.com/moddevices/mod-plugin-builder.git --recursive /mod/mod-plugin-builder
WORKDIR /mod/mod-plugin-builder
RUN git submodule init && git submodule update

# Copy the script with execution permissions
COPY --chmod=755 ./copy_modguis.sh ./

# Create a user with a home directory and add it to 'audio' group
RUN groupadd -r moddev && useradd -r -g moddev -G audio -m -d /home/moddev moddev && chmod 755 /home/moddev

USER moddev

# Build mod-host
RUN mkdir -m 777 ${WORKDIR} && \
    ./bootstrap.sh x86_64 && \
    for i in $(ls plugins/package | egrep -v 'max-gen|fluidplug|zynaddsubfx|pdlv2-labs|zeroconvo') ; do \
        ./build x86_64 $i ; \
    done && \
    cp -rfp ${WORKDIR}/plugins/* /usr/lib/lv2

USER root
RUN ./copy_modguis.sh && echo

# Build final image
FROM debian:buster

COPY --from=builder /usr/lib/lv2 /usr/lib/lv2

CMD ["echo", "Plugin compiled and copied to /usr/lib/lv2"]
