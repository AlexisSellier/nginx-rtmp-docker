FROM ubuntu:14.04
MAINTAINER Alexis Sellier
RUN apt-get update \
 && apt-get install -y wget \
                       gcc \
                       libpcre3-dev \
                       libssl-dev \
                       make \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*
WORKDIR /data/
RUN wget http://nginx.org/download/nginx-1.6.2.tar.gz -O nginx-1.6.2.tar.gz && tar -xzvf nginx-1.6.2.tar.gz
ADD nginx-rtmp-module /data/nginx-rtmp
WORKDIR /data/nginx-1.6.2/
RUN ./configure --add-module=/data/nginx-rtmp --prefix=/usr/ --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-ipv6 --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module \
  && make \
  && make install \
  && mkdir /var/lib/nginx/ \
  && chown -R www-data:www-data /var/lib/nginx/ \
  && chown -R www-data:www-data /var/log/nginx/
ADD nginx.conf /etc/nginx/nginx.conf
VOLUME ["/etc/nginx/conf.d/", "/etc/nginx/sites-enabled/", "/etc/nginx/apps-enabled/"]
CMD /usr/sbin/nginx -g "daemon off;"
EXPOSE 1935 80
