{{/*
Expand the name of the chart.
*/}}
{{- define "ksqldb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ksqldb.fullname" -}}
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
{{- define "ksqldb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ksqldb.labels" -}}
helm.sh/chart: {{ include "ksqldb.chart" . }}
{{ include "ksqldb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ksqldb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ksqldb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create a default fully qualified kafka name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "ksqldb.kafka.fullname" -}}
{{- $name := default "kafka" (index .Values "kafka" "nameOverride") -}}
{{- printf "%s-%s-headless" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Form the Kafka URL. If Kafka is installed as part of this chart, use k8s service discovery,
else use user-provided URL
*/}}
{{- define "ksqldb.kafka.bootstrapServers" -}}
{{- if (index .Values "kafka" "enabled") -}}
{{- $clientPort := 9092 | int -}}
{{- printf "%s:%d" (include "ksqldb.kafka.fullname" .) $clientPort }}
{{- else -}}
{{- printf "%s" (index .Values "kafka" "bootstrapServers") }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified schema registry name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "ksqldb.schema-registry.fullname" -}}
{{- $name := default "schema-registry" (index .Values "schema-registry" "nameOverride") -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Form the Kafka URL. If schema registry is installed as part of this chart, use k8s service discovery,
else use user-provided URL
*/}}
{{- define "ksqldb.schema-registry.url" -}}
{{- if (index .Values "schema-registry" "enabled") -}}
{{- $clientPort := 8081 | int -}}
{{- printf "%s:%d" (include "ksqldb.schema-registry.fullname" .) $clientPort }}
{{- else -}}
{{- printf "%s" (index .Values "schema-registry" "url") }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified kafka connect name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "ksqldb.kafka-connect.fullname" -}}
{{- $name := default "kafka-connect" (index .Values "kafka-connect" "nameOverride") -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Form the Kafka URL. If kafka connect is installed as part of this chart, use k8s service discovery,
else use user-provided URL
*/}}
{{- define "ksqldb.kafka-connect.url" -}}
{{- if (index .Values "kafka-connect" "enabled") -}}
{{- $clientPort := 8083 | int -}}
{{- printf "%s:%d" (include "ksqldb.kafka-connect.fullname" .) $clientPort }}
{{- else -}}
{{- printf "%s" (index .Values "kafka-connect" "url") }}
{{- end -}}
{{- end -}}

{{/*
Default service id to Release Name but allow it to be overridden
*/}}
{{- define "ksqldb.servive.id" -}}
{{- if .Values.overrideGroupId -}}
{{- .Values.overrideGroupId -}}
{{- else -}}
{{- .Release.Name -}}
{{- end -}}
{{- end -}}