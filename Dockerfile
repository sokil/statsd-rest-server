FROM ubuntu:17.10

ENV VERSION=0.5.1

ENV APT_PACKAGES="ca-certificates make  git  wget  golang"

# install requirements
RUN \
	apt-get update && \
	apt-get install -y --no-install-recommends ${APT_PACKAGES}

# download, build source and install
RUN \
	wget https://github.com/sokil/statsd-rest-server/archive/${VERSION}.tar.gz && \
	tar -zxvf ${VERSION}.tar.gz && \
	cd statsd-rest-server-${VERSION} && \
	make build && \
	chmod +x ./bin/statsd-rest-server && \
	mv ./bin/statsd-rest-server /usr/local/bin

# clear
RUN \
	rm -rf statsd-rest-server-${VERSION} && \
	apt-get purge -y ${APT_PACKAGES} && \
	apt-get autoremove -y

# start service
EXPOSE 80
ENTRYPOINT ["/usr/local/bin/statsd-rest-server"]

