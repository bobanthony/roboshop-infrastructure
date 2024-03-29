
module "vpc" {
  source = "git::https://github.com/bobanthony/tf-module-vpc.git"
  env    = var.env
  tags   = var.tags
  default_route_table = var.default_route_table
  default_vpc_id = var.default_vpc_id

  for_each = var.vpc
  vpc_cidr = each.value["vpc_cidr"]
  public_subnets = each.value["public_subnets"]
  private_subnets = each.value["private_subnets"]

}


module "docdb" {
  source = "git::https://github.com/bobanthony/tf-module-docdb.git"
  env    = var.env
  tags   = var.tags

  for_each = var.vpc
  engine = each.value["engine"]
  backup_retention_period = each.value["backup_retention_period"]
  preferred_backup_window = each.value["preferred_backup_window"]
  preferred_backup_window = each.value["preferred_backup_window"]
  skip_final_snapshot     = each.value["skip_final_snapshot"]
  engine_version          = each.value["engine_version"]
  subnet_ids              = local.db_subnet_ids
  no_of_instances         = each.value["no_of_instances"]
  instance_class          = each.value["instance_class"]



  }
output "vpc" {
    value = local.db_subnet_ids
  }

