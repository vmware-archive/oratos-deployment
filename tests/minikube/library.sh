#!/usr/bin/env bash
##-------------------------------------------------------------------
## File: library.sh
## Author : Denny <zdenny@vmware.com>
## Description :
## --
## Created : <2018-06-29>
## Updated: Time-stamp: <2018-07-02 14:56:13>
##-------------------------------------------------------------------
set -e

function verify_docker {
    if ! command -v docker 1>/dev/null 2>&1; then
        echo "docker not installed. Please confirm it's properly installed"
        exit 1
    fi
}

function verify_minikube {
    if ! command -v minikube 1>/dev/null 2>&1; then
        echo "minikube not installed. Please confirm it's properly installed"
        exit 1
    fi
    if ! command -v kubectl 1>/dev/null 2>&1; then
        echo "kubectl not installed. Please confirm it's properly installed"
        exit 1
    fi
}

function start_minikube {
    if minikube status | grep Running 1>/dev/null 2>&1; then
        echo "minikube is already started"
    else
        echo "Start minikube"
        minikube start
    fi
}
## File: library.sh ends
