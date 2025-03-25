resource "helm_release" "status_page" {
  name       = "status-page"
  namespace  = "default"
  chart      = "../../../k8s-manifests/minikube-test/helm/status-page-chart/"

  values = [
    yamlencode({
      status_page = {
        dbhost = module.rds.rds_endpoint
      }
    })
  ]
}