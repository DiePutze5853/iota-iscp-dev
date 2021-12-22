#!/usr/bin/env bash

cd "${0%/*}"

if [ -f traefik-v2.conf ]; then
    read -r -p "A config file exists and will be overwritten, are you sure you want to continue? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY])
        mv traefik-v2.conf traefik-v2.conf_backup
        chmod 600 traefik-v2.conf_backup
        ;;
        *)
        exit 1
        ;;
    esac
fi

echo "Press enter to confirm the detected value '[value]' where applicable or enter a custom value."
while [ -z "${TRAEFIK_HOSTNAME}" ]; do
    SUGGESTED_HOSTNAME="traefik.$(hostname).hosts.daobee.net"
    read -p "Traefik dashboard hostname (FQDN) [$SUGGESTED_HOSTNAME]: " -i $SUGGESTED_HOSTNAME -e TRAEFIK_HOSTNAME
    DOTS=${TRAEFIK_HOSTNAME//[^.]};
    if [ ${#DOTS} -lt 2 ] && [ ! -z ${TRAEFIK_HOSTNAME} ]; then
        echo "${TRAEFIK_HOSTNAME} is not a FQDN."
        TRAEFIK_HOSTNAME=
    fi
done

regexEmail="^(([A-Za-z0-9]+((\.|\-|\_|\+)?[A-Za-z0-9]?)*[A-Za-z0-9]+)|[A-Za-z0-9]+)@(([A-Za-z0-9]+)+((\.|\-|\_)?([A-Za-z0-9]+)+)*)+\.([A-Za-z]{2,})+$"
while [ -z "${TRAEFIK_ACME_EMAIL}" ]; do
    SUGGESTED_EMAIL="info@daobee.net"
    read -p "LetsEncrypt ACME email address [$SUGGESTED_EMAIL]: " -i $SUGGESTED_EMAIL -e TRAEFIK_ACME_EMAIL
    if [[ ! $TRAEFIK_ACME_EMAIL =~ ${regexEmail} ]]; then
        echo "${TRAEFIK_ACME_EMAIL} is not a valid email address."
        TRAEFIK_ACME_EMAIL=
    fi
done

cat << EOF > traefik-v2.conf
    TRAEFIK_HOSTNAME=$TRAEFIK_HOSTNAME
    TRAEFIK_ACME_EMAIL=$TRAEFIK_ACME_EMAIL
EOF

echo "Generating defaults..."

mkdir -p data
rm -rf ./data/acme.json 
touch ./data/acme.json
chmod 600 ./data/acme.json

DEFAULT_DASHBOARD_USER="admin"
DEFAULT_DASHBOARD_PASSWORD=$(LC_ALL=C </dev/urandom tr -dc A-Za-z0-9 | head -c 12)

printf "$DEFAULT_DASHBOARD_USER:$(openssl passwd -apr1 $DEFAULT_DASHBOARD_PASSWORD)\n" > ./data/dashboard-auth.users

echo "Default generation done.
Default dashbaord user: $DEFAULT_DASHBOARD_USER
Default dashboard password: $DEFAULT_DASHBOARD_PASSWORD
"
