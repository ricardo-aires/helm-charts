# ksqlDB

A Helm chart for ksqlDB on Kubernetes

## Introduction

This chart bootstraps a [ksqlDB](https://ksqldb.io).

ksqlDB is an event streaming database purpose-built to help developers create stream processing applications on top of Apache Kafka.

## Developing Environment

| component                                                                      | version |
| ------------------------------------------------------------------------------ | ------- |
| [Podman](https://docs.podman.io/en/latest/)                                    | v4.3.1  |
| [Minikube](https://minikube.sigs.k8s.io/docs/)                                 | v1.28.0 |
| [Kubernetes](https://kubernetes.io)                                            | v1.25.3 |
| [Helm](https://helm.sh)                                                        | v3.10.2 |
| [Confluent Platform](https://docs.confluent.io/platform/current/overview.html) | v7.3.0  |
| [ksqlDB](https://docs.ksqldb.io/en/0.28.2-ksqldb/)                             | v0.28.2 |

## Installing the Chart

Add the [chart repository](https://helm.sh/docs/helm/helm_repo_add/), if not done before:

```shell
helm repo add rhcharts https://ricardo-aires.github.io/helm-charts/
```

By default this chart is set to use the umbrella chart [kstack](https://github.com/ricardo-aires/helm-charts/charts/kstack), but can be run against an external Kafka, Schema Registry and Kafka Connect by passing:

```console
helm install --set kafka.enabled=false --set kafka.bootstrapServers=PLAINTEXT://kstack-kafka-headless.default:9092 --set schema-registry.enabled=false --set schema-registry.url=kstack-schema-registry.default:8081 --set kafka-connect.enabled=false --set kafka-connect.url=kstack-kafka-connect.default:8083 ktool rhcharts/ksqldb
NAME: ktool
LAST DEPLOYED: Tue Mar 23 18:35:37 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
** Please be patient while the ksqldb chart is being deployed in release ktool **

This chart bootstraps a ksqldb that can be accessed from within your cluster:

    ktool-ksqldb.default:8088

$
```

These commands deploy ksqlDB on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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
helm install ktool -f my-values.yaml rhcharts/ksqldb
```

A default [values.yaml](./values.yaml) is available and should be checked for more advanced usage.

### Image

By default the [confluentinc/ksqldb-server](https://hub.docker.com/r/confluentinc/ksqldb-server) is in use.

| Parameter          | Description                                    | Default                      |
| ------------------ | ---------------------------------------------- | ---------------------------- |
| `image.registry`   | Registry used to distribute the Docker Image.  | `docker.io`                  |
| `image.repository` | Docker Image of ksqlDB.                        | `confluentinc/ksqldb-server` |
| `image.tag`        | Docker Image Tag of ksqlDB.                    | `0.28.2`                      |

One can easily change the `image.tag` to use another version. When using a local/proxy docker registry we must change `image.registry` as well.

### ksqlDB Configuration

#### Deploying ksqlDB in headless mode

ksqlDB supports locked-down, "headless" deployment scenarios where interactive use of the ksqlDB cluster is disabled. For example, the CLI enables a team of users to develop and verify their queries interactively on a shared testing ksqlDB cluster. But when you deploy these queries in your production environment, you want to lock down access to ksqlDB servers, version-control the exact queries, and store them in a .sql file. This prevents users from interacting directly with the production ksqlDB cluster. For more information, see [Headless Deployment](https://docs.ksqldb.io/en/latest/operate-and-deploy/how-it-works/#headless-deployment).

To enable headless mode in this chart, simply pass the name of a ConfiMap containing the sql script file:

| Parameter              | Description                                | Default               |
| ---------------------- | ------------------------------------------ | --------------------- |
| `queriesFileConfigMap` | Name of the [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) that stores the `queries.sql` script with all the ksql queries for a given use case | `nil` |

### Ports used by ksqlDB

By default the [Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) will expose the pods in the port `8088`, `port`.

### Enable Kerberos

This chart is prepared to enable [Kerberos authentication in Kafka](https://docs.confluent.io/platform/current/kafka/authentication_sasl/authentication_sasl_gssapi.html#brokers)

| Parameter | Description | Default |
|---|---|---|
| `kerberos.enabled` | Boolean to control if Kerberos is enabled. | `false` |
| `kerberos.krb5Conf` | Name of the [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) that stores the `krb5.conf`, Kerberos [Configuration file](https://web.mit.edu/kerberos/krb5-1.12/doc/admin/conf_files/krb5_conf.html) | `nil`**¹** |
| `kerberos.keyTabSecret` | Name of the [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) that stores the [Keytab](https://web.mit.edu/kerberos/krb5-1.19/doc/basic/keytab_def.html) | `nil`**¹** |
| `serviceName` | Primary of the Principal (user, service, host) | |
| `domain` | REALM of the Principal | `nil` |

> **¹** When `kerberos.enabled` these parameters are required, and the [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) and [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) need to exist beforehand.

### Resources for Containers

Regarding the management of [Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) the next defaults regarding requests and limits are set:

| Parameter                   | Description                                                             | Default  |
| --------------------------- | ----------------------------------------------------------------------- | -------- |
| `resources.limits.cpu`      | a container cannot use more CPU than the configured limit               | `1`      |
| `resources.limits.memory`   | a container cannot use more Memory than the configured limit            | `3000Mi` |
| `resources.requests.cpu`    | a container is guaranteed to be allocated as much CPU as it requests    | `250m`   |
| `resources.requests.memory` | a container is guaranteed to be allocated as much Memory as it requests | `1000Mi` |

In terms of the JVM the next default is set:

| Parameter  | Description                        | Default                                                     |
| ---------- | ---------------------------------- | ----------------------------------------------------------- |
| `heapOpts` | The JVM Heap Options for ksqlDB.   | `"-XX:MaxRAMPercentage=50.0 -XX:InitialRAMPercentage=50.0"` |

### Advance Configuration

Check the `values.yaml` for more advance configuration such as:

- [Liveness and Readiness Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes)
- [Pod Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod)
- [Container Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container)
- [Create a pod that gets scheduled to your chosen node](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes/#create-a-pod-that-gets-scheduled-to-your-chosen-node)

