# Hive Mestastore

> Inspired by https://github.com/Gradiant/bigdata-charts and https://github.com/ssl-hep/hive-metastore/tree/main

:warning: This chart is currently under development. Some features have not been tested yet.

## Getting started

```
helm repo add heva-helm-charts https://hevaweb.github.io/heva-helm-charts/
helm install hive-metastore heva-helm-charts/hive-metastore
```

## Configuration
> See [values.yaml](./values.yaml) for full list of options

### Docker image
This chart has been tested with hive 3.1.3 using https://github.com/ssl-hep/hive-metastore/ image.

### Database
The default behavior of this chart is to create a specific database for Hive Metastore, but it is possible to use an existing database:

```yaml
postgresql:
    enabled: false

connections:
  database:
    username: hive
    password: some-password
    database: metastore
    host: my-custom.database
    port: 5432
```

:warning: Please note that currently only postgresql database is accepted and the database should have the following configuration:
```
password_encryption=md5
```

## Parameters

### Common parameters

| Name                                          | Description                                                                                                                      | Value                   |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `image.repository`                            | Docker image repository                                                                                                          | `sslhep/hive-metastore` |
| `image.pullPolicy`                            | Docker image pull policy                                                                                                         | `IfNotPresent`          |
| `image.tag`                                   | Docker image tag (immutable tags are recommended)                                                                                | `3.1.3`                 |
| `imagePullSecrets`                            | Docker registry secret names as an array                                                                                         | `[]`                    |
| `nameOverride`                                | String to partially override common.names.fullname template (will maintain the release name)                                     | `""`                    |
| `fullnameOverride`                            | String to fully override common.names.fullname template                                                                          | `""`                    |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for Airflow pods                                                                               | `true`                  |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                                                           | `""`                    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created                                                           | `false`                 |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                                                                             | `{}`                    |
| `podAnnotations`                              | Extra annotations for Airflow exporter pods                                                                                      | `{}`                    |
| `podLabels`                                   | Add extra labels to the Airflow web pods                                                                                         | `{}`                    |
| `podSecurityContext`                          | Hive pods' Security Context                                                                                                      | `{}`                    |
| `securityContext`                             | Hive containers' Security Context                                                                                                | `{}`                    |
| `service.type`                                | Hive service type                                                                                                                | `ClusterIP`             |
| `service.port`                                | Hive service port                                                                                                                | `9083`                  |
| `ingress.enabled`                             | Enable ingress record generation for Hive                                                                                        | `false`                 |
| `ingress.className`                           | Class that vill be used to implement the Ingress                                                                                 | `""`                    |
| `ingress.annotations`                         | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                    |
| `ingress.hosts`                               | List of hosts configuration                                                                                                      | `[]`                    |
| `ingress.tls`                                 | Enable TLS configuration for the hosts defined `ingress.hosts` parameter                                                         | `[]`                    |
| `resources`                                   | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                | `{}`                    |
| `nodeSelector`                                | Node labels for Hive pods assignment                                                                                             | `{}`                    |
| `tolerations`                                 | Tolerations for Hive pods assignment                                                                                             | `[]`                    |
| `affinity`                                    | Affinity for Hive pods assignment (evaluated as a template)                                                                      | `{}`                    |
| `extraEnvVars`                                | Extra environment variables passed to Hive pods                                                                                  | `[]`                    |
| `extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for Hive pods                                                           | `[]`                    |
| `extraVolumes`                                | Optionally specify extra list of additional volumes for Hive pods                                                                | `[]`                    |

### Hive Parameters

| Name                            | Description                                                  | Value                                    |
| ------------------------------- | ------------------------------------------------------------ | ---------------------------------------- |
| `connections.database.username` | Database username                                            | `hive`                                   |
| `connections.database.password` | Database password                                            | `hive`                                   |
| `connections.database.database` | Hive database name                                           | `metastore`                              |
| `connections.database.host`     | Databas host                                                 | `{{ .Release.Name }}-postgresql`         |
| `connections.database.port`     | Database port                                                | `5432`                                   |
| `conf.hiveSite`                 | Set of hive-site.xml configuration                           | `{}`                                     |
| `objectStore.sslEnabled`        | Value of fs.s3a.connection.ssl.enabled in hive-site.xml file | `false`                                  |
| `objectStore.endpoint`          | Value of fs.s3a.endpoint in hive-site.xml file               | `nil`                                    |
| `objectStore.accessKeyId`       | Value of fs.s3a.access.key in hive-site.xml file             | `nil`                                    |
| `objectStore.secretAccessKey`   | Value of fs.s3a.secret.key in hive-site.xml file             | `nil`                                    |
| `objectStore.pathStyle`         | Value of fs.s3a.path.style.access in hive-site.xml file      | `true`                                   |
| `objectStore.impl`              | Value of fs.s3a.impl in hive-site.xml file                   | `org.apache.hadoop.fs.s3a.S3AFileSystem` |
| `log.level.meta`                | Log level of logger.meta in log4j properties                 | `debug`                                  |
| `log.level.hive`                | Log level of logger.hive in log4j properties                 | `info`                                   |
| `log.level.datanucleusorg`      | Log level of logger.datanucleusorg in log4j properties       | `info`                                   |
| `log.level.datanucleus`         | Log level of logger.datanucleus in log4j properties          | `info`                                   |
| `log.level.root`                | Log level of logger.root in log4j properties                 | `info`                                   |

### Database Paramaters

| Name                                          | Description                                                                           | Value                     |
| --------------------------------------------- | ------------------------------------------------------------------------------------- | ------------------------- |
| `postgresql.enabled`                          | Switch to enable or disable the PostgreSQL helm chart                                 | `true`                    |
| `postgresql.global.postgresql.auth.username`  | Name for a custom user to create (overrides `auth.username`)                          | `hive`                    |
| `postgresql.global.postgresql.auth.password`  | Password for the custom user to create (overrides `auth.password`)                    | `hive`                    |
| `postgresql.global.postgresql.auth.database`  | Name for a custom database to create (overrides `auth.database`)                      | `metastore`               |
| `postgresql.primary.persistence.enabled`      | Enable PostgreSQL Primary data persistence using PVC                                  | `true`                    |
| `postgresql.primary.persistence.accessModes`  | PVC Access Mode for PostgreSQL volume                                                 | `["ReadWriteOnce"]`       |
| `postgresql.primary.extendedConfiguration`    | Extended PostgreSQL Primary configuration (appended to main or default configuration) | `password_encryption=md5` |
| `postgresql.primary.service.ports.postgresql` | PostgreSQL service port                                                               | `5432`                    |
