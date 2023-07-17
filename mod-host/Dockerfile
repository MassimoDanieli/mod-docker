FROM debian:bookworm

ENV REBUILD=true
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -q -y --no-install-recommends ca-certificates wget \
    && rm -rf /var/lib/apt/lists/* 

# Add KX Studio Repo, install plugins
RUN dpkg --purge kxstudio-repos-gcc5 \
    && wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_10.0.3_all.deb \
    && dpkg -i kxstudio-repos_10.0.3_all.deb \
    && rm kxstudio-repos_10.0.3_all.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends libreadline-dev liblilv-dev lilv-utils libfftw3-dev libjack-jackd2-dev git python3 python3.11 \
    && rm -rf /var/lib/apt/lists/* 

# Build mod-host
RUN git clone https://github.com/moddevices/mod-host.git /mod/mod-host/source \
    && apt install build-essential -y --no-install-recommends \
    && mkdir /usr/include/lilv \
    && cp /usr/include/lilv-0/lilv/lilv.h /usr/include/lilv/ \
    && make -C /mod/mod-host/source && make install -C  /mod/mod-host/source

# Install LV2 Plugins from MOD Repo (to extract modgui data)
RUN apt-get update \
    && apt-get install -y --no-install-recommends kxstudio-meta-audio-plugins kxstudio-meta-audio-plugins-lv2 \
    && rm -rf /var/lib/apt/lists/* 

# install gosu for a better su+exec command
ARG GOSU_VERSION=1.12
RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true 

# Generate user same as host and Run mod host.
CMD groupadd -f $GROUP_ID \
	&& useradd -m -g $GROUP_ID -G audio -u $USER_ID $USER_NAME || true  \
	&& gosu ${USER_NAME} mod-host -v -n -p 5555
