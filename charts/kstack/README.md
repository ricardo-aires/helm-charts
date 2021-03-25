# kstack

A Helm chart for kstack on Kubernetes

## Introduction

This chart serves as an umbrella to the next charts:

### Confluent

Helm charts that deploy components of the [Confluent Platform](https://www.confluent.io/product/confluent-platform) (open source and community).

- [Zookeeper](../zookeeper/)
- [Kafka](../kafka/)
- [Schema Registry](../schema-registry/)
- [Kafka Connect](../kafka-connect/)
- [Kafka REST](../kafka-rest/)
- [ksqldb](../ksqldb/)

### Other Kafka Tools

- [Kafrdop](../kafdrop/)

## Developing Environment

- [Docker Desktop](https://www.docker.com/get-started) for Mac 3.1.0
  - [Kubernetes](https://kubernetes.io) v1.19.3
- [Helm](https://helm.sh) v3.5.2
- [Confluent Platform](https://docs.confluent.io/platform/current/overview.html) 6.1.0
  - [Zookeeper](https://zookeeper.apache.org/doc/r3.6.2/index.html) 3.5.8
  - [Kafka](https://kafka.apache.org/27/documentation.html) 2.7

## Installing the Chart

Add the [chart repository](https://helm.sh/docs/helm/helm_repo_add/), if not done before:

```shell
helm repo add rhcharts https://ricardo-aires.github.io/helm-charts/
```

Run the installer with the default configuration.

```console
helm install ktool rhcharts/kstack
```

One can run the:

- [helm list](https://helm.sh/docs/helm/helm_list/) command to list releases installed
- [helm status](https://helm.sh/docs/helm/helm_status/) to display the status of the named release
- [helm test](https://helm.sh/docs/helm/helm_test/) to run tests for a release

To [uninstall](https://helm.sh/docs/helm/helm_uninstall/) the `ktool` deployment run:

```console
helm uninstall ktool
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install ktool -f my-values.yaml rhcharts/kstack
```

A default [values.yaml](./values.yaml) is available and should be checked for more advanced usage. Example:

```yaml
kafka:
  enabled: true
  heapOpts: -Xmx2048m -Xms2048m
  data:
    storageSize: 20Gi
  zookeeper:
    enabled: true
    replicaCount: 5

schema-registry:
  enabled: true

kafka-connect:
  enabled: true

ksqldb:
  enabled: false

kafdrop:
  enabled: true
```
