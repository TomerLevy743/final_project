resource "helm_release" "monitoring" {
  name      = "monitoring"
  namespace = "default"
  chart     = "../k8s-manifests/minikube-test/helm/monitoring-chart/"

  values = [yamlencode({
    grafana = {
      enabled  = true
      service  = {
        type = "ClusterIP"
      }
      ingress = {
        enabled = false
      }
      ini = {
        server = {
          domain              = "status-page.org"
          root_url            = "%(protocol)s://%(domain)s/grafana/"
          serve_from_sub_path = true
        }
      }
      persistence = {
        enabled          = true
        storageClassName = "gp2"
        accessModes      = ["ReadWriteOnce"]
        size             = "10Gi"
      }
      adminUser     = "admin"
      adminPassword = "admin123"
    }
  })]
}