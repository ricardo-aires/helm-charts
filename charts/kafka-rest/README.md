# Kafka REST

A Helm chart for Confluent Kafka REST on Kubernetes

## Introduction

This chart bootstraps a [Kafka REST](https://docs.confluent.io/platform/current/kafka-rest/production-deployment/rest-proxy/index.html) using the [Confluent](https://docs.confluent.io/platform/current/connect/index.html) stable version.

The Confluent REST Proxy provides a RESTful interface to a Kafka cluster.

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

By default this chart is set to use the umbrella chart [kstack](https://github.com/ricardo-aires/helm-charts/charts/kstack), but can be run against an external Kafka and Schema Registry by passing:

```console
helm install --set kafka.enabled=false --set kafka.bootstrapServers=PLAINTEXT://kstack-kafka-headless.default:9092 --set schema-registry.enabled=false --set schema-registry.url=kstack-schema-registry.default:8081 ktool rhcharts/kafka-rest
NAME: ktool
LAST DEPLOYED: Tue Mar 23 18:35:37 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
** Please be patient while the kafka-rest chart is being deployed in release ktool **

This chart bootstraps a Confluent Kafka REST that can be accessed from within your cluster:

    ktool-kafka-rest.default:8082

$
```

These commands deploy Kafka REST on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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
helm install ktool -f my-values.yaml rhcharts/kafka-rest
```

A default [values.yaml](./values.yaml) is available and should be checked for more advanced usage.

### Image

By default the [confluentinc/cp-kafka-rest](https://hub.docker.com/r/confluentinc/cp-kafka-rest) is in use.

| Parameter          | Description                                    | Default                      |
| ------------------ | ---------------------------------------------- | ---------------------------- |
| `image.registry`   | Registry used to distribute the Docker Image.  | `docker.io`                  |
| `image.repository` | Docker Image of Confluent Kafka Connect.       | `confluentinc/cp-kafka-rest` |
| `image.tag`        | Docker Image Tag of Confluent Kafka Connect .  | `7.3.0`                      |

One can easily change the `image.tag` to use another version. When using a local/proxy docker registry we must change `image.registry` as well.

### Confluent Kafka REST Configuration

#### Ports used by Schema Registry

By default the [Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) will expose the pods in the port `8082`, `port`.

#### Enable Kerberos

This chart is prepared to enable [Kerberos authentication in Kafka](https://docs.confluent.io/platform/current/kafka/authentication_sasl/authentication_sasl_gssapi.html#brokers)

| Parameter | Description | Default |
|---|---|---|
| `kerberos.enabled` | Boolean to control if Kerberos is enabled. | `false` |
| `kerberos.krb5Conf` | Name of the [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) that stores the `krb5.conf`, Kerberos [Configuration file](https://web.mit.edu/kerberos/krb5-1.12/doc/admin/conf_files/krb5_conf.html) | `nil`**¹** |
| `kerberos.keyTabSecret` | Name of the [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) that stores the [Keytab](https://web.mit.edu/kerberos/krb5-1.19/doc/basic/keytab_def.html) | `nil`**¹** |
| `serviceName` | Primary of the Principal (user, service, host) | |
| `domain` | REALM of the Principal | `BFL.LOCAL` |

> **¹** When `kerberos.enabled` these parameters are required, and the [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) and [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) need to exist beforehand.

### Resources for Containers

Regarding the management of [Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) the next defaults regarding requests and limits are set:

| Parameter                   | Description                                                             | Default  |
| --------------------------- | ----------------------------------------------------------------------- | -------- |
| `resources.limits.cpu`      | a container cannot use more CPU than the configured limit               | `200m`   |
| `resources.limits.memory`   | a container cannot use more Memory than the configured limit            | `660Mi`  |
| `resources.requests.cpu`    | a container is guaranteed to be allocated as much CPU as it requests    | `100m`   |
| `resources.requests.memory` | a container is guaranteed to be allocated as much Memory as it requests | `200Mi`  |

In terms of the JVM the next default is set:

| Parameter  | Description                            | Default                                                     |
| ---------- | -------------------------------------- | ----------------------------------------------------------- |
| `heapOpts` | The JVM Heap Options for Kafka Rest.   | `"-XX:MaxRAMPercentage=75.0 -XX:InitialRAMPercentage=50.0"` |

### Advance Configuration

Check the `values.yaml` for more advance configuration such as:

- [Liveness and Readiness Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes)
- [Pod Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod)
- [Container Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container)
- [Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
