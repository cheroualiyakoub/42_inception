FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx \
	openssl && apt-get clean

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout "/etc/nginx/ssl/nginx.key" -out "/etc/nginx/ssl/nginx.crt" \
	-subj "/C=DE/ST=Baden-württemberg/L=Heilbronn/O=42Heilbronn/OU=Heilb/CN=ycheroua.42.fr"


#COPY ./conf/index.html /var/www/html
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 443


CMD ["nginx", "-g", "daemon off;"]
