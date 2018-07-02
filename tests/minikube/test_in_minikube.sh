#!/usr/bin/env bash

set -e
source library.sh

function generate_certs {
    if [ -f ./secrets/loggregator-tls-certs.yml ]; then
        echo "No need to generate secrets"
    else
        (cd ./secrets && bash ./generate-tls-certs.sh)
    fi
}

verify_docker
verify_minikube

case $1 in
    deploy)
        start_minikube
        cd ../../
        generate_certs
        bash -e ./deploy.sh -s && bash -e ./status.sh
        ;;
    destroy)
        cd ../../
        ./destroy.sh
        ;;
    *)
        echo "No supported action: $1"
        exit 1
esac
