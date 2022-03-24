FROM nginx:stable

RUN rm /etc/nginx/conf.d/default.conf

COPY .docker/nginx/conf.d/*.conf /etc/nginx/conf.d/
