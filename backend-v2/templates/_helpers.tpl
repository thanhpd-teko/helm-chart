{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "teko.name" -}}
{{- default $.Release.Name $.Values.serviceName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name. This should be serviceName, unless using Release.Name as service name
*/}}
{{- define "teko.fullname" -}}
{{- default $.Release.Name $.Values.serviceName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "teko.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "teko.labels" -}}
app.kubernetes.io/name: {{ include "teko.name" . }}
helm.sh/chart: {{ include "teko.chart" . }}
{{- if $.Chart.AppVersion }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ $.Release.Service }}
{{- end -}}


{{- define "teko.env" -}}
{{- with . -}}
env:
{{- range $key, $val := . }} 
- name: {{ $key }}
  {{- if hasPrefix "\"secret:" ($val | quote) }}
  valueFrom:   
    secretKeyRef:
      name: {{$val | trimPrefix "secret:" | splitList "." | first }}
      key: {{ $val | splitList "." | rest | join "." }}
  {{- else if hasPrefix "\"configmap:" ($val | quote) }}
  valueFrom:   
    configMapKeyRef:
      name: {{ $val | trimPrefix "configmap:" | splitList "." | first }}
      key: {{ $val | splitList "." | rest | join "." }}
  {{- else }}
  value: {{ $val | quote }}
  {{- end }}
{{- end }}
{{- end }}
{{- end -}}


{{- define "teko.cmd" -}}
{{- with .command }}
command: {{ . | toYaml | nindent 2 }}
{{- end }}
{{- with .args }}
args: {{ . | toYaml | nindent 2 }}
{{- end }}
{{- end -}}


{{- define "teko.resources" -}}
{{- with . }}
resources: {{ . | toYaml | nindent 2 }}
{{- end }}
{{- end -}}
