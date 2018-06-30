#!/bin/bash

set -e

tls_certs_header='
apiVersion: v1
kind: Secret
metadata:
  name: loggregator-tls-certs
  namespace: oratos
type: Opaque
data:
'

b64cmd=base64
if [ "$(uname | tr '[:upper:]' '[:lower:]')" = "linux" ]; then
  b64cmd="base64 -w 0"
fi

docker run -v "$PWD/loggregator-tls-certs:/output" loggregator/certs
if [ "$(uname | tr '[:upper:]' '[:lower:]')" = "linux" ]; then
  sudo chown -R "$(whoami)" loggregator-tls-certs
fi

echo "$tls_certs_header" > loggregator-tls-certs.yml
for f in loggregator-tls-certs/*; do
    fname=$(basename "$f")
    content=$("$b64cmd" "$f")
    echo "  $fname: $content" >> loggregator-tls-certs.yml
done
