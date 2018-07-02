#!/usr/bin/env bash

set -e

function verify_docker {
    if ! command -v docker >/dev/null 2>&1; then
        echo "docker not installed. Please confirm it's properly installed"
        exit 1
    fi
}

function verify_minikube {
    if ! command -v minikube >/dev/null 2>&1; then
        echo "minikube not installed. Please confirm it's properly installed"
        exit 1
    fi
    if ! command -v kubectl >/dev/null 2>&1; then
        echo "kubectl not installed. Please confirm it's properly installed"
        exit 1
    fi
}

function start_minikube {
    if minikube status | grep Running >/dev/null 2>&1; then
        echo "minikube is already started"
    else
        echo "Start minikube"
        minikube start
    fi
}
