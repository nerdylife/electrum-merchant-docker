FROM debian:stretch

MAINTAINER Marcel Braun <nerdlife@protonmail.com>

# Install build tools
RUN apt update
RUN apt install -y \
	make build-essential libssl-dev zlib1g-dev \
	libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
	libncurses5-dev libncursesw5-dev xz-utils tk-dev \
	nginx git

# Configure Apache
#COPY default /etc/nginx/sites-available/

# Install Python
RUN cd /tmp && \
	wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tgz && \
	tar xvf Python-3.6.4.tgz && \
	cd Python-3.6.4 && \
	./configure --enable-optimizations && \
	make -j8 && \
	make altinstall

# Install Electrum
RUN apt install -y \
	python3-setuptools python3-pip

RUN cd /tmp && \
	wget https://download.electrum.org/3.3.4/Electrum-3.3.4.tar.gz && \
	python3.6 -m pip install --user Electrum-3.3.4.tar.gz[fast]

RUN ln -s /root/.local/bin/electrum /usr/bin/electrum

# Install Merchant
RUN pip3.6 install electrum-merchant requests

# Install Websocket
RUN cd /tmp \
	&& git clone https://github.com/dpallot/simple-websocket-server \
	&& cd simple-websocket-server \
	&& python3.6 setup.py install

# Cleanup
RUN rm -Rf /tmp/*
#RUN apt-get purge -y --auto-remove \
#	build-essential python3-pip python3-setuptools \
#	build-essential libssl-dev zlib1g-dev \
#	libbz2-dev libreadline-dev libsqlite3-dev wget llvm \
#	libncurses5-dev libncursesw5-dev xz-utils tk-dev \
#	git

# Copy init script
COPY init.sh /
RUN chmod a+x /init.sh
CMD ["/init.sh"]
