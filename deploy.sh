#!/bin/bash

set -e

function single_yml_config {
    for f in \
        namespaces/*.yml \
        configmaps/*.yml \
        secrets/*.yml \
        services/*.yml \
        daemonsets/*.yml \
        deployments/*.yml \
        statefulsets/*.yml \
        roles/*.yml \
        "$@" \
    ; do
        if [ "$skip_loggregator" == "yes" ] && \
               echo "$f" | grep -E 'loggregator.*.yml|log-cache.*.yml' >/dev/null; then
                continue
        fi
        echo ---
        cat "$f";
    done
}

function patch_loggregator_objects {
    # this is done in order to force rolling of components on update
    # for instance if a configmap or secret value is changed and needs to be
    # reloaded from disk or env
    patch='{"spec": {"template": {"metadata": {"labels": {"randomversion": "'$RANDOM'"}}}}}'
    kubectl patch statefulset log-cache --namespace oratos --patch "$patch"
    kubectl patch deployment log-cache-nozzle --namespace oratos --patch "$patch"
    kubectl patch deployment log-cache-scheduler --namespace oratos --patch "$patch"
    kubectl patch deployment loggregator-rlp --namespace oratos --patch "$patch"
    kubectl patch deployment loggregator-router --namespace oratos --patch "$patch"
    kubectl patch daemonset loggregator-fluentd --namespace oratos --patch "$patch"

    # optinal features
    if kubectl get deployment syslog-nozzle > /dev/null 2>&1; then
        kubectl patch deployment syslog-nozzle --namespace oratos --patch "$patch"
    fi
    if kubectl get deployment loggregator-emitter > /dev/null 2>&1; then
        kubectl patch deployment loggregator-emitter --namespace oratos --patch "$patch"
    fi
}

BIN_NAME=$(basename "$0")

help()
{
cat <<EOF
${BIN_NAME}
Usage: ${BIN_NAME} [ -s|--skip-loggregator ]

Run deployment test
  -s, --skip-loggregator   skip loggregator for testing
  -h, --help               display this help
EOF
    exit 0
}

skip_loggregator="no"

for arg in "$@"
do
    case "$arg" in
        -s|--skip-loggregator)
            shift
            skip_loggregator="yes"
            ;;
        -h|--help)
            help
            shift
            exit 0
            ;;
        --)
            echo "break"
            shift
            break
            ;;
    esac
done

single_yml_config "$@" | kubectl apply -f -
if [ "$skip_loggregator" = "no" ]; then
    patch_loggregator_objects
fi
