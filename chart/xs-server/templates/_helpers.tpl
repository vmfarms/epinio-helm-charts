{{/*
Expand the name of the chart.
*/}}
{{- define "xs-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "xs-server.fullname" -}}
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
{{- define "xs-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "xs-server.labels" -}}
helm.sh/chart: {{ include "xs-server.chart" . }}
{{ include "xs-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "xs-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "xs-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "xs-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "xs-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Epinio Service Name
*/}}
{{- define "epinio.ServiceName" -}}
{{- if .Values.epinio.serviceName }}
{{- .Values.epinio.serviceName | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Generate a random username.
*/}}
{{- define "xs-server.randomUsername" -}}
{{- randAlphaNum 8 -}}
{{- end }}

{{/*
Generate a random password.
*/}}
{{- define "xs-server.randomPassword" -}}
{{- randAlphaNum 16 -}}
{{- end }}

{{/*
Generate a random UID or string.
*/}}
{{- define "xs-server.randomUID" -}}
{{- randAlphaNum 12 -}}
{{- end }}

{{/*
Renders a value that contains template perhaps with scope if the scope is present.
Usage:
{{ include "xs-server.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $ ) }}
{{ include "xs-server.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $ "scope" $app ) }}
*/}}

{{- define "xs-server.tplvalues.render" -}}
{{- $value := typeIs "string" .value | ternary .value (.value | toYaml) }}
{{- if contains "{{" (toJson .value) }}
  {{- if .scope }}
      {{- tpl (cat "{{- with $.RelativeScope -}}" $value "{{- end }}") (merge (dict "RelativeScope" .scope) .context) }}
  {{- else }}
    {{- tpl $value .context }}
  {{- end }}
{{- else }}
    {{- $value }}
{{- end }}
{{- end -}}

