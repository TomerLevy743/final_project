# Fluent Bit Installation
resource "helm_release" "fluent_bit" {
  name       = "fluent-bit"
  namespace  = "default"

  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"

  values = [<<EOF
backend:
  type: es
  es:
    host: "elasticsearch-master.default.svc.cluster.local"
    port: 9200
    tls: on
    logstash_prefix: "eks-logs"
    time_key: "@timestamp"           # Set the timestamp field to @timestamp
    time_key_format: "%Y-%m-%dT%H:%M:%S"  # ISO 8601 format for the timestamp

config:
  customParsers: |
    [PARSER]
        Name docker_no_time
        Format json
        Time_Keep Off
        Time_Key time
        Time_Format %Y-%m-%dT%H:%M:%S.%L
EOF
  ]
}

# Elasticsearch Installation
resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  namespace  = "default"

  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"

  values = [<<EOF
replicas: 1
minimumMasterNodes: 1
resources:
  requests:
    memory: "1Gi"
    cpu: "500m"
  limits:
    memory: "2Gi"
    cpu: "1"
secret:
  enabled: true
  password: "admin123"

esConfig:
  elasticsearch.yml: |
    xpack.security.enabled: false
    xpack.monitoring.templates.enabled: true
  elasticsearch.ssl.verificationMode: "none"
EOF
  ]
}
