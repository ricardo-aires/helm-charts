# Helm Charts

Collection of basic [helm charts](https://helm.sh) to be used in labs.

## Description

This repository holds some [helm charts](https://helm.sh) developed to be use in laps. To add the [chart repository](https://helm.sh/docs/helm/helm_repo_add/)

```shell
helm repo add rhcharts https://ricardo-aires.github.io/helm-charts/
```

To list [available charts](https://helm.sh/docs/helm/helm_search_repo/)

```shell
$ helm search repo rhcharts
NAME              	CHART VERSION	APP VERSION	DESCRIPTION
rhcharts/kafka   	0.1.0        	6.1.1      	A Helm chart for Confluent Kafka on Kubernetes
rhcharts/zookeeper	0.1.0        	6.1.1      	A Helm chart for Confluent Zookeeper on Kubernetes

$
```

To [install](https://helm.sh/docs/helm/helm_install/) a specific chart

```shells
$ helm install zkp rhcharts/zookeeper
NAME: zkp
LAST DEPLOYED: Tue Mar 23 15:49:18 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
** Please be patient while the zookeeper chart is being deployed in release zkp **

This chart bootstraps an ensemble Apache Zookeeper Servers made of "3" servers using the Confluent stable version that can be accessed from within your cluster:

    zkp-zookeeper-headless.default:2181

To connect to your ZooKeeper server run the following commands:

    $ kubectl exec -it -n default zkp-zookeeper-0 -- zookeeper-shell zkp-zookeeper-headless.default:2181

$
```

## Available Charts

### Confluent

Helm charts that deploy components of the [Confluent Platform](https://www.confluent.io/product/confluent-platform) (open source and community).

- [Zookeeper](./charts/zookeeper/)
- [Kafka](./charts/kafka/)