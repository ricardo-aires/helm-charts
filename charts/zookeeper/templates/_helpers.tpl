{{/*
Expand the name of the chart.
*/}}
{{- define "zookeeper.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "zookeeper.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "zookeeper.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "zookeeper.labels" -}}
helm.sh/chart: {{ include "zookeeper.chart" . }}
{{ include "zookeeper.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "zookeeper.selectorLabels" -}}
app: {{ .Release.Name }}-{{ include "zookeeper.name" . }}
app.kubernetes.io/name: {{ include "zookeeper.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create a server list string based on fullname, namespace, # of servers
in a format like "zkhost1:port:port;zkhost2:port:port"
*/}}
{{- define "zookeeper.serverlist" -}}
{{- $namespace := .Release.Namespace }}
{{- $name := include "zookeeper.fullname" . -}}
{{- $peersPort := .Values.port.peers -}}
{{- $leaderElectionPort := .Values.port.leader -}}
{{- $zk := dict "servers" (list) -}}
{{- range $idx, $v := until (int .Values.replicaCount) }}
{{- $noop := printf "%s-%d.%s-headless.%s.svc.cluster.local:%d:%d" $name $idx $name $namespace (int $peersPort) (int $leaderElectionPort) | append $zk.servers | set $zk "servers" -}}
{{- end }}
{{- printf "%s" (join ";" $zk.servers) | quote -}}
{{- end -}}

{{/*
Set the minimum number of servers that must be available during evictions.
This should be (replicaCount/2) + 1
*/}}
{{- define "zookeeper.minAvailable" -}}
minAvailable: {{ (add (div .Values.replicaCount 2) 1) }}
{{- end }}%
