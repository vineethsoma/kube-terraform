provider "kubernetes" {}

resource "kubernetes_replication_controller" "nginx" {
  metadata {
    name = "nginx-example"

    labels {
      App = "nginx"
    }
  }

  spec {
    replicas = 4

    selector {
      App = "nginx"
    }

    template {
      container {
        image = "nginx:1.7.8"
        name  = "example"

        port {
          container_port = 80
        }

        resources {
          limits {
            cpu    = "0.5"
            memory = "512Mi"
          }

          requests {
            cpu    = "250m"
            memory = "50Mi"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-example"
  }

  spec {
    selector {
      App = "${kubernetes_replication_controller.nginx.metadata.0.labels.App}"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
