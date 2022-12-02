# kstack

A Helm chart to deploy the Data Platform's Kafka environment, and related services, on Kubernetes

## Introduction

This chart serves as an umbrella to the next charts:

### Confluent

Components of the [Confluent Platform](https://www.confluent.io/product/confluent-platform) (open source and community) that can be deployed by this chart:

- [Zookeeper](../zookeeper/)
- [Kafka](../kafka/)
- [Schema Registry](../schema-registry/)
- [Kafka Connect](../kafka-connect/)
- [Kafka REST](../kafka-rest/)
- [ksqldb](../ksqldb/)

### Other Kafka Tools

- [Kafrdop](../kafdrop/)

## Developing Environment

| component                                                                      | version |
| ------------------------------------------------------------------------------ | ------- |
| [Podman](https://docs.podman.io/en/latest/)                                    | v4.3.1  |
| [Minikube](https://minikube.sigs.k8s.io/docs/)                                 | v1.28.0 |
| [Kubernetes](https://kubernetes.io)                                            | v1.25.3 |
| [Helm](https://helm.sh)                                                        | v3.10.2 |
| [Confluent Platform](https://docs.confluent.io/platform/current/overview.html) | v7.3.0  |

## Installing the Chart

Add the [chart repository](https://helm.sh/docs/helm/helm_repo_add/), if not done before:

```shell
helm repo add rhcharts https://ricardo-aires.github.io/helm-charts/
```

To search a specific [available chart](https://helm.sh/docs/helm/helm_search_repo/)

```console
$ helm search repo zookeeper
NAME                    CHART VERSION   APP VERSION     DESCRIPTION
rhcharts/zookeeper  0.2.2           6.1.1           A Helm chart for Confluent Zookeeper on Kubernetes

```

> If no keyword is used all charts will be listed.

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
helm install ktool -f my-values.yaml hrhcharts/kstack
```

A default [values.yaml](./values.yaml) is available and should be checked for more advanced usage. Example:

```yaml
kafka:
  enabled: true
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
