{{/*
Expand the name of the chart.
*/}}
{{- define "kafdrop.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kafdrop.fullname" -}}
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
{{- define "kafdrop.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kafdrop.labels" -}}
helm.sh/chart: {{ include "kafdrop.chart" . }}
{{ include "kafdrop.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kafdrop.selectorLabels" -}}
app: {{ .Release.Name }}-{{ include "kafdrop.name" . }}
app.kubernetes.io/name: {{ include "kafdrop.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create a default fully qualified kafka name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kafdrop.kafka.fullname" -}}
{{- $name := default "kafka" (index .Values "kafka" "nameOverride") -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Form the Kafka URL. If Kafka is installed as part of this chart, use k8s service discovery,
else use user-provided URL
*/}}
{{- define "kafdrop.kafka.bootstrapServers" -}}
{{- if (index .Values "kafka" "enabled") -}}
{{- $name := default "kafka"  (include "kafdrop.kafka.fullname" .) -}}
{{- $namespace := .Release.Namespace }}
{{- $clientPort := 9092 | int -}}
{{- range $k, $e := until (.Values.kafka.replicaCount|int) -}}
{{- if $k}}{{- printf ","}}{{end}}
{{- printf "%s-%d.%s-headless.%s.svc.cluster.local:%d" $name $k $name $namespace $clientPort -}}
{{- end -}}
{{- else -}}
{{- printf "%s" (index .Values "kafka" "bootstrapServers") }}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified schema registry name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kafdrop.schema-registry.fullname" -}}
{{- $name := default "schema-registry" (index .Values "schema-registry" "nameOverride") -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Form the schema registry URL. If schema registry is installed as part of this chart, use k8s service discovery,
else use user-provided URL
*/}}
{{- define "kafdrop.schema-registry.url" -}}
{{- if (index .Values "schema-registry" "enabled") -}}
{{- $clientPort := 8081 | int -}}
{{- printf "http://%s:%d" (include "kafdrop.schema-registry.fullname" .) $clientPort }}
{{- else -}}
{{- printf "%s" (index .Values "schema-registry" "url") }}
{{- end -}}
{{- end -}}
