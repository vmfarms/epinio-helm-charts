{{/*
Expand the name of the chart.
*/}}
{{- define "scheduler.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 52 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "scheduler.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 52 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 52 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 52 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "scheduler.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 52 | trimSuffix "-" }}
{{- end }}
{{/*
Common labels
*/}}
{{- define "scheduler.labels" -}}
app.kubernetes.io/managed-by: epinio
app.kubernetes.io/part-of: {{ .Release.Namespace | quote }}
helm.sh/chart: {{ include "scheduler.chart" . }}
{{ include "scheduler.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "scheduler.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.epinio.appName | quote }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "scheduler.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "scheduler.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Removes characters that are invalid for kubernetes resource names from the
given string
*/}}
{{- define "epinio-name-sanitize" -}}
{{ regexReplaceAll "[^-a-z0-9]*" . "" }}
{{- end }}

{{/*
Resource name sanitization and truncation.
- Always suffix the sha1sum (40 characters long)
- Always add an "r" prefix to make sure we don't have leading digits
- The rest of the characters up to 63 are the original string with invalid
character removed.
*/}}
{{- define "epinio-truncate" -}}
{{ print "r" (trunc 10 (include "epinio-name-sanitize" .)) "-" (sha1sum .) }}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "scheduler.annotations" -}}
epinio.io/created-by: {{ .Values.epinio.username | quote }}
{{- end }}

{{/*
Application listening port
*/}}
{{- define "epinio-app-listening-port" -}}
{{ default 8080 (default (dict "appListeningPort" "8080") .Values.userConfig).appListeningPort }}
{{- end }}
