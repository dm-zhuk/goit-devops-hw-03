{{- define "django-app.fullname" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "django-app.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{ include "django-app.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "django-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "django-app.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
