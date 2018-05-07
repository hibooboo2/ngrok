#! /bin/bash -ex

if [ -d ~/certs/live/${DOMAIN} ]; then
  echo ${DOMAIN} RENEW

  docker run -it --rm --name certbot  \
   -v ~/certs:/etc/letsencrypt   certbot/certbot renew
else
  echo ${DOMAIN} is new need to get certs

  docker run -it --rm --name certbot  \
   -v ~/certs:/etc/letsencrypt   certbot/certbot certonly \
    --manual -d *.${DOMAIN} --agree-tos --manual-public-ip-logging-ok \
     --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory
fi

cp ~/certs/live/${DOMAIN}/fullchain.pem assets/client/tls/ngrokroot.crt

cp ~/certs/live/${DOMAIN}/fullchain.pem assets/server/tls/snakeoil.crt

cp ~/certs/live/${DOMAIN}/privkey.pem assets/server/tls/snakeoil.key

DOMAIN=${DOMAIN} make all
