resource "helm_release" "monitoring" {
  name      = "monitoring"
  namespace = "default"
  chart     = "../k8s-manifests/minikube-test/helm/monitoring-chart/"
  values = [file("../k8s-manifests/minikube-test/helm/monitoring-chart/values.yaml")]
}
