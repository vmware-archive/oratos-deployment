#!/usr/bin/env bash
##-------------------------------------------------------------------
## File: test_in_minikube.sh
## Author : Denny <zdenny@vmware.com>
## Description :
## --
## Created : <2018-06-29>
## Updated: Time-stamp: <2018-07-02 14:56:16>
##-------------------------------------------------------------------
set -e
. library.sh

function generate_certs {
    if [ -f ./secrets/loggregator-tls-certs.yml ]; then
        echo "No need to generate secrets"
    else
        (cd ./secrets && bash -e ./generate-tls-certs.sh)
    fi
}
################################################################################
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
                       

## File: test_in_minikube.sh ends
