FROM debian:bullseye

# Install Nginx and OpenSSL
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean

# Create SSL directory and generate self-signed certificate
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "/etc/nginx/ssl/nginx.key" -out "/etc/nginx/ssl/nginx.crt" \
    -subj "/C=DE/ST=Baden-württemberg/L=Heilbronn/O=42Heilbronn/OU=Heilb/CN=ycheroua.42.fr"

# Copy Nginx configuration file
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

# Expose HTTPS port
EXPOSE 443

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
