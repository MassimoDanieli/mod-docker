FROM mod-plugin-builder

ENV REBUILD=true
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"] 

# Install dependencies
RUN apt-get update \
	&& apt-get -y install --no-install-recommends virtualenv python3-pip python3-dev python3-venv libpython3.11-dev python3-setuptools git build-essential libasound2-dev libjack-jackd2-dev liblilv-dev libjpeg-dev zlib1g-dev wget curl \	
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*

# Build mod-ui 
ENV PYTHON_VERSION 3.11  
WORKDIR /mod/mod-ui
RUN git clone https://github.com/moddevices/mod-ui.git . \
	&& virtualenv modui-env \
	&& . modui-env/bin/activate \
	&& sed -i -e 's/git+https:\/\/github.com\/dlitz\/pycrypto.git@master#egg=pycrypto/PyCryptodomex/' requirements.txt \
	&& pip3 install --no-cache-dir -r requirements.txt \
	&& sed -i -e 's/collections.MutableMapping/collections.abc.MutableMapping/' modui-env/lib/python$PYTHON_VERSION/site-packages/tornado/httputil.py \
	&& sed -i -e 's/Image.ANTIALIAS/Image.Resampling.LANCZOS/' modtools/pedalboard.py \
	&& sed -i -e 's/var\ DEBUG\ \=\ true/var\ DEBUG\ \=\ false/' html/index.html \
	&& pip3 install --no-cache-dir git+https://github.com/moddevices/browsepy.git backports.shutil-get-terminal-size scandir \
	&& chmod +x start_browsepy.sh \
	&& make -C utils \
	&& wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
	&& chmod +x wait-for-it.sh \
	&& chown :audio -R . \
	&& chmod -R 775 .

# install gosu for a better su+exec command
ARG GOSU_VERSION=1.12
RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true 

ENV MOD_DEV_ENVIRONMENT=0 
RUN chown :audio -R . \
	&& chmod -R 775 .

# Generate user same as host . (It will need to connect to host jack with same username)
CMD groupadd -f $GROUP_ID \
	&& useradd -m -g $GROUP_ID -G audio -u $USER_ID $USER_NAME || true  \
	&& gosu ${USER_NAME} bash -c 'mod-host -p 5555 -f 5556 && start_browsepy.sh $MOD_USER_FILES_DIR && python3 server.py'
