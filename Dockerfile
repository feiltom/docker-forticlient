FROM alpine:latest
MAINTAINER Donny Jie <dong115@uwindsor.ca>
LABEL version="0.2"
LABEL description="Forticlient in docker"

# Install dependency
RUN echo '@community http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories \
    && apk add --no-cache ca-certificates wget iproute2 ppp ppp-daemon bash expect file libgcc libstdc++ musl-obstack gcompat@community 
    
# Install fortivpn client unofficial .deb, link dylib
RUN cd /opt && wget 'http://www.canada-today.ca/forticlient.tar.gz' -O forticlient-sslvpn.tgz \
    && tar -xzf forticlient-sslvpn.tgz \
    && rm -rf forticlient-sslvpn.tgz \
    && echo $'debug dump\n\
lock\n\
noauth\n\
proxyarp\n\
nodefaultroute\n\
modem\n\
noipdefault\n\
lcp-echo-interval 60\n\
lcp-echo-failure 4\n\
' > /etc/ppp/options \
    && rm -rf /var/cache/apk/* /tmp/*

# Copy runfiles
COPY forticlient /usr/bin/forticlient
COPY start.sh /start.sh

CMD [ "/start.sh" ]
