output "cluster_id" {
  value       = aws_rds_cluster.default.id
  description = "RDS Cluster ID"
}

output "cluster_arn" {
  value       = aws_rds_cluster.default.arn
  description = "RDS Cluster ARN"
}

output "subnet_group_id" {
  value       = var.db_subnet_group_name
  description = "RDS subnet group ID"
}

output "subnet_group_arn" {
  value       = aws_db_subnet_group.default.arn
  description = "RDS subnet group ARN. Only available if created by the module"
}

output "security_group_id" {
  value       = aws_security_group.db.id
  description = "DB Security group ID"
}

output "security_group_arn" {
  value       = aws_security_group.db.arn
  description = "DB Security group ID"
}

output "ssm_db_host" {
  value       = aws_ssm_parameter.db_host.name
  description = "SSM Parameter Store - Database host endpoint"
}

output "ssm_db_host_ro" {
  value       = aws_ssm_parameter.db_host_ro.name
  description = "SSM Parameter Store - Database host endpoint (Read Only)"
}

output "ssm_db_master_username" {
  value       = aws_ssm_parameter.db_user.name
  description = "SSM Parameter Store - Database Master username"
}

output "ssm_db_master_password" {
  value       = aws_ssm_parameter.db_password.name
  description = "SSM Parameter Store - Database Master password"
}

output "ssm_db_name" {
  value       = aws_ssm_parameter.db_database.name
  description = "SSM Parameter Store - Database name"
}

output "ssm_db_port" {
  value       = aws_ssm_parameter.db_port.name
  description = "SSM Parameter Store - Database port"
}

output "endpoint" {
  value       = aws_rds_cluster.default.endpoint
  description = "Database writer endpoint"
}

output "ro_endpoint" {
  value       = aws_rds_cluster.default.reader_endpoint
  description = "Database reader endpoint"
}

output "cluster_resource_id" {
  value       = aws_rds_cluster.default.cluster_resource_id
  description = "Cluster resource Id"
}

output "as_alarm_arn" {
  value       = try(aws_appautoscaling_policy.replicas[0].alarm_arns, "")
  description = "List of CloudWatch alarm ARNs associated with the scaling policy"
}

output "as_name" {
  value       = try(aws_appautoscaling_policy.replicas[0].name, "")
  description = "Scaling policy's name"
}

output "as_policy_type" {
  value       = try(aws_appautoscaling_policy.replicas[0].policy_type, "")
  description = "Scaling policy's type"
}
