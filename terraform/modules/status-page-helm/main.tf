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


# resource "kubernetes_config_map" "grafana_config" {
#   metadata {
#     name      = "monitoring-grafana"
#     namespace = "default"

#     labels = {
#       "app.kubernetes.io/instance"    = "monitoring"
#       "app.kubernetes.io/managed-by"  = "Helm"
#       "app.kubernetes.io/name"        = "grafana"
#       "app.kubernetes.io/version"     = "10.1.2"
#       "helm.sh/chart"                 = "grafana-6.59.5"
#     }

#     annotations = {
#       "meta.helm.sh/release-name"      = "monitoring"
#       "meta.helm.sh/release-namespace" = "default"
#     }
#   }

#   data = {
#     "grafana.ini" = chomp(<<-EOT
#     [server]
#     domain = status-page.org
#     root_url = %(protocol)s://%(domain)s/grafana/
#     serve_from_sub_path = true
#     EOT
#     )
#   }
#   lifecycle {
#     ignore_changes = [data]
#   }
# }