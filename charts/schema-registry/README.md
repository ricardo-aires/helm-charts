# Schema Registry

A Helm chart for Confluent Schema Registry on Kubernetes

## Introduction

This chart bootstraps a [Schema Registry](https://docs.confluent.io/platform/current/schema-registry/index.html) using the [Confluent](https://docs.confluent.io/home/kafka-intro.html) stable version.

Schema Registry is a distributed storage layer for schemas which uses Kafka as its underlying storage mechanism.

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

Schema Registry lives outside of and separately from your Kafka brokers. By default this chart is set to use the umbrella chart [kstack](https://github.com/ricardo-aires/helm-charts/charts/kstack), but can be run against an external Kafka by:

```console
helm install --set kafka.enabled=false --set kafka.bootstrapServers=PLAINTEXT://kstack-kafka-headless.default:9092 ktool rhcharts/schema-registry
NAME: ktool
LAST DEPLOYED: Tue Mar 23 18:35:37 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
** Please be patient while the schema-registry chart is being deployed in release ktool **

This chart bootstraps a Confluent Schema Registry that can be accessed from within your cluster:

    ktool-schema-registry.default:8081

$
```

These commands deploy Schema Registry on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

One can run the:

- [helm list](https://helm.sh/docs/helm/helm_list/) command to list releases installed
- [helm status](https://helm.sh/docs/helm/helm_status/) to display the status of the named release
- [helm test](https://helm.sh/docs/helm/helm_test/) to run tests for a release

The chart uses the [compatibility](https://docs.confluent.io/platform/current/schema-registry/develop/api.html#id1) API endpoint to check availability.

To [uninstall](https://helm.sh/docs/helm/helm_uninstall/) the `ktool` deployment run:

```console
helm uninstall ktool
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install ktool -f my-values.yaml rhcharts/schema-registry
```

A default [values.yaml](./values.yaml) is available and should be checked for more advanced usage.

### Image

By default the [confluentinc/cp-schema-registry](https://hub.docker.com/r/confluentinc/cp-schema-registry) is in use.

| Parameter          | Description                                    | Default                           |
| ------------------ | ---------------------------------------------- | --------------------------------- |
| `image.registry`   | Registry used to distribute the Docker Image.  | `docker.io`                       |
| `image.repository` | Docker Image of Confluent Schema Registry.     | `confluentinc/cp-schema-registry` |
| `image.tag`        | Docker Image Tag of Confluent Schema Registry. | `7.3.0`                           |

One can easily change the `image.tag` to use another version. When using a local/proxy docker registry we must change `image.registry` as well.

### Confluent Schema Registry Configuration

The next configuration related to Kafka Schema Registry are available:

| Parameter                    | Description                                                                    | Default                 |
| ---------------------------- | ------------------------------------------------------------------------------ | ----------------------- |
| `leaderEligibility`          | If true, this node can participate in primary election.                        | `true`                  |
| `accessControl.allowMethods` | Set value to Jetty `Access-Control-Allow-Origin` header for specified methods. | `GET,POST,PUT,OPTIONS`  |
| `accessControl.AllowOrigin`  | Set value for Jetty `Access-Control-Allow-Origin` header.                      | `"*"`                   |
| `schemaCompatibilityLevel`   | The schema compatibility type.                                                 | `full`                  |

More information can be found in the [Confluent Documentation](https://docs.confluent.io/platform/current/schema-registry/installation/config.html#).

### Ports used by Schema Registry

By default the [Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) will expose the pods in the port `8081`, `port`.

### Enable Kerberos

This chart is prepared to enable [Kerberos authentication in Kafka](https://docs.confluent.io/platform/current/kafka/authentication_sasl/authentication_sasl_gssapi.html#brokers)

| Parameter               | Description                                | Default |
| ----------------------- | ------------------------------------------ | ------- |
| `kerberos.enabled`      | Boolean to control if Kerberos is enabled. | `false` |
| `kerberos.krb5Conf`     | Name of the [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) that stores the `krb5.conf`, Kerberos [Configuration file](https://web.mit.edu/kerberos/krb5-1.12/doc/admin/conf_files/krb5_conf.html) | `nil`**¹** |
| `kerberos.keyTabSecret` | Name of the [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) that stores the [Keytab](https://web.mit.edu/kerberos/krb5-1.19/doc/basic/keytab_def.html) | `nil`**¹** |
| `kafka.kerberos.serviceName` | Primary of the Principal (user, service, host) used to connect to Kafka Brokers | `nil` |
| `kafka.kerberos.domain` | REALM of the Principal used to connect to Kafka Brokers | `nil` |

> **¹** When `kerberos.enabled` these parameters are required, and the [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) and [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) need to exist beforehand.

### Resources for Containers

Regarding the management of [Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) the next defaults regarding requests and limits are set:

| Parameter                   | Description                                                             | Default  |
| --------------------------- | ----------------------------------------------------------------------- | -------- |
| `resources.limits.cpu`      | a container cannot use more CPU than the configured limit               | `200m`   |
| `resources.limits.memory`   | a container cannot use more Memory than the configured limit            | `1400Mi` |
| `resources.requests.cpu`    | a container is guaranteed to be allocated as much CPU as it requests    | `100m`   |
| `resources.requests.memory` | a container is guaranteed to be allocated as much Memory as it requests | `512Mi`  |

In terms of the JVM the next default is set:

| Parameter  | Description                               | Default                                                     |
| ---------- | ----------------------------------------- | ----------------------------------------------------------- |
| `heapOpts` | The JVM Heap Options for Schema Registry. | `"-XX:MaxRAMPercentage=75.0 -XX:InitialRAMPercentage=50.0"` |

### Advance Configuration

Check the `values.yaml` for more advance configuration such as:

- [Liveness and Readiness Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes)
- [Pod Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod)
- [Container Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container)
