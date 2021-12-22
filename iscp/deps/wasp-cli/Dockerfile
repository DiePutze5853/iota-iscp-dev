FROM ubuntu as build

COPY wasp-cli ./
#COPY wasp-cli.json ./

RUN apt-get update
RUN apt-get install -y ca-certificates
RUN update-ca-certificates

EXPOSE 8545/tcp

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]