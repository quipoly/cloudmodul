#!/usr/bin/env bash

export TSIG_KEY="4+dxEg2CLnBF2ULmM0T3gsDuCQiHlU5GTjBEMO4NdH0="

deploy_challenge() {
    local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"

    # Add your logic here to update the DNS record with the challenge token
    # You can use your DNS provider's API or command-line tools to update the record

    # Example with BIND:
    nsupdate -k "${TSIG_KEY}" <<EOF
    server 170.17.149.28
    zone yannic.erzinger.users.bbw-it.ch.
    update delete "_acme-challenge.${DOMAIN}."
    update add "_acme-challenge.${DOMAIN}." 60 TXT "${TOKEN_VALUE}"
    send
    EOF
}

clean_challenge() {
    local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"

    # Add your logic here to remove the DNS record after the challenge is complete
    # You can use your DNS provider's API or command-line tools to remove the record

    # Example with BIND:
    nsupdate -k "${TSIG_KEY}" <<EOF
    server 170.17.149.28
    zone yannic.erzinger.users.bbw-it.ch.
    update delete "_acme-challenge.${DOMAIN}."
    send
    EOF
}

deploy_cert() {
    local DOMAIN="${1}" KEYFILE="${2}" CERTFILE="${3}" FULLCHAINFILE="${4}" CHAINFILE="${5}" TIMESTAMP="${6}"

    # Add your logic here to deploy the generated certificate to your server
    # For example, you may need to copy the files to the appropriate location

    # Example:
    cp "${KEYFILE}" /path/to/your/private/key
    cp "${CERTFILE}" /path/to/your/certificate
}

HANDLER="$1"; shift
"$HANDLER" "$@"
