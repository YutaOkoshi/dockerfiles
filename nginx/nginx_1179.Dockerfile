FROM nginx:1.17.9

# RUN rm /etc/nginx/nginx.conf
# RUN rm /etc/nginx/conf.d/default.conf

RUN rm /etc/nginx/conf.d/default.conf
# COPY nginx.conf /etc/nginx/conf.d
