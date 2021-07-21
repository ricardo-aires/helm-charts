# Kafka Connect UI

A Helm chart for Landoop Kafka Connect UI on Kubernetes

## Introduction

This chart bootstraps a [Kafka Connect UI](https://github.com/lensesio/kafka-connect-ui), a web tool for the [Kafka Connect](https://docs.confluent.io/platform/current/schema-registry/index.html).

> Keep in mind that this is available because some of the Devs still use it to ease the development phase.

## Developing Environment

- [Docker Desktop](https://www.docker.com/get-started) for Mac 3.5.2
  - [Kubernetes](https://kubernetes.io) v1.21.2
- [Helm](https://helm.sh) v3.6.3
- [Confluent Platform](https://docs.confluent.io/platform/current/overview.html) 6.2.0
  - [Zookeeper](https://zookeeper.apache.org/doc/r3.6.2/index.html) 3.5.9
  - [Kafka](https://kafka.apache.org/27/documentation.html) 2.8

## Installing the Chart

Add the [chart repository](https://helm.sh/docs/helm/helm_repo_add/), if not done before:

```shell
helm repo add rhcharts https://ricardo-aires.github.io/helm-charts/
```

Kafka Connect lives outside of and separately from your Kafka Kafka Connect. We will need to pass a valid Kafka Connect URL.

```console
$ helm upgrade --install --set kafkaConnectURL=http://k-kafka-connect:8083 kui ./kafka-connect-ui/
Release "kui" has been upgraded. Happy Helming!
NAME: kui
LAST DEPLOYED: Wed Jul 21 14:35:09 2021
NAMESPACE: default
STATUS: deployed
REVISION: 2
TEST SUITE: None

$
```

These commands deploy Kafka Connect UI on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

One can run the:

- [helm list](https://helm.sh/docs/helm/helm_list/) command to list releases installed
- [helm status](https://helm.sh/docs/helm/helm_status/) to display the status of the named release
- [helm test](https://helm.sh/docs/helm/helm_test/) to run tests for a release

The chart uses the [compatibility](https://docs.confluent.io/platform/current/schema-registry/develop/api.html#id1) API endpoint to check availability.

To [uninstall](https://helm.sh/docs/helm/helm_uninstall/) the `ktool` deployment run:

```console
helm uninstall sr-ui
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install sr-ui -f my-values.yaml rhcharts/kafka-connect-ui
```

A default [values.yaml](./values.yaml) is available and should be checked for more advanced usage.

### Image

By default the [landoop/kafka-connect-ui](https://hub.docker.com/r/landoop/kafka-connect-ui) is in use.

| Parameter          | Description                                    | Default                      |
| ------------------ | ---------------------------------------------- | ---------------------------- |
| `image.registry`   | Registry used to distribute the Docker Image.  | `docker.io`                  |
| `image.repository` | Docker Image of Confluent Kafka Connect.       | `landoop/kafka-connect-ui`   |
| `image.tag`        | Docker Image Tag of Confluent Kafka Connect.   | `latest`                     |

One can easily change the `image.tag` to use another version. When using a local/proxy docker registry we must change `image.registry` as well.

### Kafka Connect UI Configuration

The next configuration related to Kafka Connect UI are available:

| Parameter         | Description                               | Default |
| ----------------- | ----------------------------------------- | ------- |
| `kafkaConnectURL` | Endpoint for the Kafka Connect to manage. | `nil`   |

More information can be found in the [Docker Image Documentation](https://hub.docker.com/r/landoop/kafka-connect-ui).

### Ports used by Kafka Connect

By default the [Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) will expose the pods in the port `8000`, `port`.

```yaml
service:
  type: NodePort
  port: 8000
  nodePort: 30800
```

If `service.type` is change to `NodePort` the created service will be a [nodeport service](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport) that will expose kafka-connect-ui in the  `nodePort` given.

### Resources for Containers

Regarding the management of [Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) the next defaults regarding requests and limits are set:

| Parameter                   | Description                                                             | Default  |
| --------------------------- | ----------------------------------------------------------------------- | -------- |
| `resources.limits.cpu`      | a container cannot use more CPU than the configured limit               | `100m`   |
| `resources.limits.memory`   | a container cannot use more Memory than the configured limit            | `1400Mi` |
| `resources.requests.cpu`    | a container is guaranteed to be allocated as much CPU as it requests    | `10m`    |
| `resources.requests.memory` | a container is guaranteed to be allocated as much Memory as it requests | `220Mi`  |

### Advance Configuration

Check the `values.yaml` for more advance configuration such as:

- [Liveness and Readiness Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes)
- [Pod Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod)
- [Container Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container)
