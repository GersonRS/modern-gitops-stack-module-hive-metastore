locals {
  domain      = format("hive-metastore.%s", trimprefix("${var.subdomain}.${var.base_domain}", "."))
  domain_full = format("hive-metastore.%s.%s", trimprefix("${var.subdomain}.${var.cluster_name}", "."), var.base_domain)

  helm_values = [{
    hive-metastore = {
      # image = {
      #   repository = "334077612733.dkr.ecr.sa-east-1.amazonaws.com/solinftec/orion"
      #   pullPolicy = "Always"
      #   tag        = "deepstore-hive-1.0.0"
      # }
      serviceAccount = {
        create = true
      }
      service = {
        type = "ClusterIP"
        port = 9083
      }
      ingress = {
        enabled : true
        className : "traefik"
        annotations = {
          "cert-manager.io/cluster-issuer"                   = "${var.cluster_issuer}"
          "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
          "traefik.ingress.kubernetes.io/router.tls"         = "true"
        }
        hosts = [
          {
            host = local.domain
            paths = [{
              path     = "/"
              pathType = "ImplementationSpecific"
            }]
          },
          {
            host = local.domain_full
            paths = [{
              path     = "/"
              pathType = "ImplementationSpecific"
            }]
          }
        ]
        tls = [{
          secretName = "hive-metastore-ingres-tls"
          hosts = [
            local.domain,
            local.domain_full
          ]
        }]
      }
      resources = {
        requests = { for k, v in var.resources.requests : k => v if v != null }
        limits   = { for k, v in var.resources.limits : k => v if v != null }
      }
      # connections = {
      #   database = {
      #     username = "${var.database.user}"
      #     password = "${var.database.password}"
      #     database = "${var.database.database}"
      #     host     = "${var.database.service}"
      #     port     = 5432
      #   }
      # }
      conf = {
        hiveSite = {
          "hive.metastore.warehouse.dir"          = "s3a://warehouse/metastore"
          "javax.jdo.option.ConnectionDriverName" = "org.postgresql.Driver"
        }
      }
      objectStore = {
        sslEnabled      = false
        endpoint        = "http://${var.storage.endpoint}"
        accessKeyId     = "${var.storage.access_key}"
        secretAccessKey = "${var.storage.secret_access_key}"
        pathStyle       = true
        impl            = "org.apache.hadoop.fs.s3a.S3AFileSystem"
      }
      log = {
        level = {
          meta           = "debug"
          hive           = "info"
          datanucleusorg = "info"
          datanucleus    = "info"
          root           = "info"
        }
      }
      postgresql = {
        enabled = true
      }
    }
  }]
}
