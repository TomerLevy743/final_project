resource "helm_release" "status_page" {
  name      = "status-page"
  namespace = "default"
  chart     = "../k8s-manifests/minikube-test/helm/status-page-chart/"

  values = [
    yamlencode({
      nginx = {
        image = {
          repository = var.image_repository_nginx
          tag        = "latest"
        }
      }
      status_page = {
        image = {
          repository = var.image_repository_statuspage
          tag        = "latest"
        }
        dbhost     = var.rds_endpoint
        dbname     = var.db_name
        dbuser     = var.db_user
        dbpassword = var.rds_password
      }
    })
  ]
}
