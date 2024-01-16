module "postgres" {
  source = "../modules/apps/postgres"

  name = "postgres"
  environment = {
    POSTGRES_PASSWORD : "password"
  }
  ports = [
    {
      host_port : 5432,
      container_port : 5432
    }
  ]
}

module "cluster" {
  source = "../modules/apps/clt"

  name         = "clt"
  cluster_path = "./cluster"
}

module "grafana" {
  source = "../modules/grafana"
}

module "build" {
  source = "../modules/apps/builder"

  namespace = "mycloud"
  cluster   = module.cluster
  services = concat(
    [module.postgres.data],
    values(module.grafana.grafana_services),
    values(module.grafana.utils_services),
  )
}