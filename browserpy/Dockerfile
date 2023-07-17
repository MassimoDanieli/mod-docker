FROM mod-host

ENV REBUILD=true
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"] 

# Install dependencies
RUN apt-get update \
	&& apt-get -y install --no-install-recommends virtualenv python3-pip python3-dev python3-venv python3-setuptools git build-essential libasound2-dev libjack-jackd2-dev liblilv-dev libjpeg-dev zlib1g-dev wget curl \	
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*

# Build browserpy
WORKDIR /mod/browserpy
RUN virtualenv browserpy-env \
	&& . browserpy-env/bin/activate \
	&& pip3 install --no-cache-dir git+https://github.com/moddevices/browsepy.git backports.shutil-get-terminal-size scandir \
	&& chown :audio -R . \
	&& chmod -R 775 . \
	&& wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
	&& chmod +x wait-for-it.sh

# install gosu for a better su+exec command
ARG GOSU_VERSION=1.12
RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true 

ENV DATADIR /data/user-files

# Generate user same as host. (It will need to connect to host jack with same username)
CMD groupadd -f $GROUP_ID \
	&& useradd -m -g $GROUP_ID -G audio -u $USER_ID $USER_NAME || true  \
	&& gosu ${USER_NAME} bash -c '/mod/browserpy/bin/browserpy --directory $DATADIR -p 8081'
