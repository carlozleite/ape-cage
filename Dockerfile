FROM httpd:alpine

RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
RUN apk upgrade --update-cache --available
RUN apk add --update python iproute2 jo wget
ADD ape-cage /ape-cage
RUN wget --no-check-certificate https://github.com/msoap/shell2http/releases/download/1.10/shell2http-1.10.linux.386.tar.gz -O /tmp/shell2http.tar.gz
RUN tar -xvzf /tmp/shell2http.tar.gz -C /ape-cage/bin/ shell2http
RUN rm -f /tmp/shell2http.tar.gz
RUN sed -i s/enp0s8/eth0/g /ape-cage/etc/*
CMD ["/ape-cage/ape_server.sh"]
