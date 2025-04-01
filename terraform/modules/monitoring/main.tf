resource "helm_release" "monitoring" {
  name      = "monitoring"
  namespace = "default"
  chart     = "../k8s-manifests/minikube-test/helm/monitoring-chart/"
  force_update = true

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
resource "null_resource" "update_configmap" {
  provisioner "local-exec" {
      command = "bash eks-config.sh && kubectl apply -f ../k8s-manifests/minikube-test/helm/monitoring-chart/grafana-config.yaml && kubectl rollout restart deployment monitoring-grafana -n default"

  }
  depends_on = [ helm_release.monitoring ]
}