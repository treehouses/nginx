ARG BASE=
FROM ${BASE}

RUN apk --no-cache update && apk add nginx \
    && mkdir -p /run/nginx \
    && sed -i "s/ssl_session_cache shared:SSL:2m;/#ssl_session_cache shared:SSL:2m;/g" /etc/nginx/nginx.conf

COPY default.conf /etc/nginx/conf.d

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]