resource "helm_release" "monitoring" {
  name      = "monitoring"
  namespace = "default"
  chart     = "../k8s-manifests/minikube-test/helm/monitoring-chart/"
  force_update = true
  values = [
    file("../k8s-manifests/minikube-test/helm/monitoring-chart/values.yaml")
  ]
}
resource "null_resource" "update_configmap" {
  provisioner "local-exec" {
      command = "bash eks-config.sh && kubectl apply -f ../k8s-manifests/minikube-test/helm/monitoring-chart/grafana-config.yaml && kubectl rollout restart deployment monitoring-grafana -n default"

  }
  depends_on = [ helm_release.monitoring ]
}