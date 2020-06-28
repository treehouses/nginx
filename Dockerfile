FROM treehouses/alpine 

LABEL org.opencontainers.image.maintainer="vmnet8 <vmnet8@ole.org>" \
      org.opencontainers.image.title="NGINX" \
      org.opencontainers.image.description="NGINX on raspberry pi" \
      org.opencontainers.image.description="NGINX on x86" \
      org.opencontainers.image.licenses="AGPL v3.0" \
      org.opencontainers.image.url="https://hub.docker.com/r/treehouses/nginx/" \
      org.opencontainers.image.source="https://github.com/treehouses/nginx"

#ENV NGINX_VERSION 1.16

RUN apk --no-cache add nginx \
    && mkdir -p /run/nginx \
    && sed -i "s/ssl_session_cache shared:SSL:2m;/#ssl_session_cache shared:SSL:2m;/g" /etc/nginx/nginx.conf

COPY default.conf /etc/nginx/conf.d

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
		
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

