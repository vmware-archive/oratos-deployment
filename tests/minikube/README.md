By default, we test in concourse.

Alternatively, here we enable developers to test in minikube locally and easily

- Deploy & Verify
```
cd ./deployment/tests/minikube
make
```

- Destroy
```
cd ./deployment/tests/minikube
make destroy
```
