locals {
  helm_values = [{
    hive-metastore = {
      image = {
        repository = "334077612733.dkr.ecr.sa-east-1.amazonaws.com/solinftec/orion"
        pullPolicy = "Always"
        tag        = "deepstore-hive-1.0.0"
      }
      serviceAccount = {
        create = true
      }
      service = {
        type = ClusterIP
        port = 9083
      }
      ingress = {
        enabled = false
      }
      resources = {}
      # limits:
      #   cpu: 100m
      #   memory: 128Mi
      # requests:
      #   cpu: 100m
      #   memory: 128Mi
      affinity = {
        nodeAffinity = {
          requiredDuringSchedulingIgnoredDuringExecution = {
            nodeSelectorTerms = [{
              matchExpressions = {
                key      = "ng-workgroup"
                operator = "In"
                values   = ["storage"]
              }
            }]
          }
        }
      }

      connections = {
        database = {
          username = "usr_hive"
          password = "YO4youuteNFgrc7Hoo"
          database = "hive_metastore"
          host     = "log-hive-metastore-prod-br.c90iouqmac88.sa-east-1.rds.amazonaws.com"
          port     = 5432
        }
      }
      conf = {
        hiveSite = {
          hive.metastore.warehouse.dir          = "s3a://warehouse/metastore"
          javax.jdo.option.ConnectionDriverName = "org.postgresql.Driver"
        }
      }
      objectStore = {
        sslEnabled      = false
        endpoint        = "http://bigdata-storage-hl.deepstore-bigdata.svc.cluster.local:9000"
        accessKeyId     = "hive-ds-bg"
        secretAccessKey = "hiv@9931ms-sec"
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
        enabled = false
        # global:
        #   postgresql:
        #     auth:
        #       username: admin
        #       password: admin
        #       database: metastore_db
        primary = {
          persistence = {
            enabled      = false
            storageClass = gp2
            accessModes = [
              "ReadWriteOnce"
            ]
          }
          extendedConfiguration = [
            "password_encryption=md5"
          ]
          service = {
            ports = {
              postgresql = "5432"
            }
          }
        }
      }
    }
  }]
}
