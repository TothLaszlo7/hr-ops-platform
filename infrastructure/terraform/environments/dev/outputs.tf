output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "db_port" {
  value = module.rds.db_port
}

output "db_name" {
  value = module.rds.db_name
}

output "master_user_secret_arn" {
  value     = module.rds.master_user_secret_arn
  sensitive = true
}