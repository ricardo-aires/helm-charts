# Kafdrop

A Helm chart for Kafdrop on Kubernetes

## Introduction

This chart bootstraps a [Kafdrop](https://github.com/obsidiandynamics/kafdrop).

Kafdrop is a web UI for viewing Kafka topics and browsing consumer groups. The tool displays information such as brokers, topics, partitions, consumers, and lets you view messages.

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

By default this chart is set to use the umbrella chart [kstack](https://github.com/ricardo-aires/helm-charts/charts/kstack), but can be run against an external Kafka by passing:

```console
helm install --set kafka.enabled=false --set kafka.bootstrapServers=kstack-kafka-headless.default:9092 ktool rhcharts/kafdrop
NAME: ktool
LAST DEPLOYED: Tue Mar 23 18:35:37 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
** Please be patient while the kafdrop chart is being deployed in release ktool **

This chart bootstraps a kafdrop that can be accessed from within your cluster:

    ktool-kafdrop.default:9000

$
```

These commands deploy kafdrop on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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
helm install ktool -f my-values.yaml rhcharts/kafdrop
```

A default [values.yaml](./values.yaml) is available and should be checked for more advanced usage.

### Image

By default the [obsidiandynamics/kafdrop](https://hub.docker.com/r/obsidiandynamics/kafdrop) is in use.

| Parameter          | Description                                    | Default                    |
| ------------------ | ---------------------------------------------- | -------------------------- |
| `image.registry`   | Registry used to distribute the Docker Image.  | `docker.io`                |
| `image.repository` | Docker Image of Kafdrop.                       | `obsidiandynamics/kafdrop` |
| `image.tag`        | Docker Image Tag of Kafdrop.                   | `3.27.0`                   |

One can easily change the `image.tag` to use another version. When using a local/proxy docker registry we must change `image.registry` as well.

### Ports used by Kafdrop

By default the [Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) will expose the pods in the port `9000`, `port`.

```yaml
service:
  type: NodePort
  port: 9000
  nodePort: 30900
```

If `service.type` is change to `NodePort` the created service will be a [nodeport service](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport) that will expose Kafdrop in the  `nodePort` given.

### Resources for Containers

Regarding the management of [Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) the next defaults regarding requests and limits are set:

| Parameter                   | Description                                                             | Default  |
| --------------------------- | ----------------------------------------------------------------------- | -------- |
| `resources.limits.cpu`      | a container cannot use more CPU than the configured limit               | `400m`   |
| `resources.limits.memory`   | a container cannot use more Memory than the configured limit            | `440Mi`  |
| `resources.requests.cpu`    | a container is guaranteed to be allocated as much CPU as it requests    | `100m`   |
| `resources.requests.memory` | a container is guaranteed to be allocated as much Memory as it requests | `220Mi`  |

In terms of the JVM the next default is set:

| Parameter  | Description                         | Default                                                     |
| ---------- | ----------------------------------- | ----------------------------------------------------------- |
| `heapOpts` | The JVM Heap Options for Kafdrop.   | `"-XX:MaxRAMPercentage=75.0 -XX:InitialRAMPercentage=50.0"` |

### Advance Configuration

Check the `values.yaml` for more advance configuration such as:

- [Liveness and Readiness Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes)
- [Pod Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod)
- [Container Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container)
- [Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
