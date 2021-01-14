FROM alpine:3 as builder

RUN apk update && apk add autoconf automake libtool pkgconf build-base \
	glib-dev libconfig-dev libnice-dev jansson-dev openssl-dev libsrtp-dev \
	gengetopt git libwebsockets-dev

WORKDIR /usr/src/

RUN git clone https://github.com/sctplab/usrsctp && cd /usr/src/usrsctp  && \
	./bootstrap && \
	./configure --prefix=/usr --disable-programs --disable-inet --disable-inet6 && \
	make && make install

COPY . /usr/src/janus-gateway

WORKDIR /usr/src/janus-gateway

RUN ./autogen.sh && ./configure --prefix=/opt/janus && make -j4 && make install

CMD ["/opt/janus/bin/janus"]
