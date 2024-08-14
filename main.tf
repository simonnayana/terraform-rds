
resource "aws_db_subnet_group" "default" {
  name       = "db-subnet-group"
  subnet_ids = var.subnet_ids

}

resource "random_password" "database" {
  length  = 20
  special = false
}

# ----------------------------- Security Group for rds ---------------------------------

data "aws_subnet" "database" {
  for_each = toset(var.subnet_ids)
  id       = each.key
}

resource "aws_security_group" "db" {
  name   = "db-default"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    protocol    = "tcp"
    to_port     = 5432
    cidr_blocks = var.subnet_ids
  }

  ingress {
    from_port   = 5432
    protocol    = "tcp"
    to_port     = 5432
    cidr_blocks = var.sg_cidr_blocks
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# --------------------------------- RDS ----------------------------------------



resource "aws_rds_cluster" "default" {
  cluster_identifier                  = "rds-aurora-cluster"
  engine                              = var.db_engine
  engine_version                      = var.db_engine_version
  apply_immediately                   = var.apply_immediately
  availability_zones                  = var.availability_zones
  master_username                     = var.db_root_user
  deletion_protection                 = var.delete_protect
  master_password                     = random_password.database.result
  database_name                       = var.db_name
  snapshot_identifier                 = var.snapshot_identifier
  backup_retention_period             = var.backup_retention_period
  preferred_backup_window             = var.preferred_backup_window
  final_snapshot_identifier           = "rds-aurora-cluster-final-snap"
  skip_final_snapshot                 = false
  db_subnet_group_name                = aws_db_subnet_group.default.name
  vpc_security_group_ids              = [aws_security_group.db.id]
  storage_encrypted                   = var.storage_encrypted
  kms_key_id                          = var.kms_key_id
  iam_database_authentication_enabled = var.iam_database_authentication_enabled


  lifecycle {
    ignore_changes = [
      engine_version,
      master_username,
      master_password,
      db_subnet_group_name,
      availability_zones,
      snapshot_identifier
    ]
    prevent_destroy = true
  }
}


resource "aws_rds_cluster_instance" "default" {
  depends_on = [
    aws_rds_cluster.default
  ]
  count                        = var.db_instance_count
  identifier                   = "instance-${count.index}"
  engine                       = var.db_engine
  cluster_identifier           = aws_rds_cluster.default.id
  instance_class               = var.db_instance_class
  performance_insights_enabled = var.performance_insights


  lifecycle {
    prevent_destroy = true
  }
}

# ---------------------------- Store RDS Details in Parameter Store ---------------------------------

resource "aws_ssm_parameter" "db_host" {
  name  = "/rds-aurora-cluster/db/host"
  type  = "SecureString"
  value = aws_rds_cluster.default.endpoint

}

resource "aws_ssm_parameter" "db_host_ro" {
  name  = "/rds-aurora-cluster/db/ro/host"
  type  = "SecureString"
  value = aws_rds_cluster.default.reader_endpoint
}

resource "aws_ssm_parameter" "db_user" {
  name  = "/rds-aurora-cluster/db/user"
  type  = "SecureString"
  value = aws_rds_cluster.default.master_username

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/rds-aurora-cluster/db/password"
  type  = "SecureString"
  value = random_password.database.result

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "db_database" {
  name  = "/rds-aurora-cluster/db/database"
  type  = "SecureString"
  value = var.db_name

}

resource "aws_ssm_parameter" "db_port" {
  name  = "/rds-aurora-cluster/db/port"
  type  = "SecureString"
  value = aws_rds_cluster.default.port

}

resource "aws_appautoscaling_target" "replicas" {
  count              = var.autoscaling_enabled == "true" ? 1 : 0
  service_namespace  = "rds"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  resource_id        = "cluster:${aws_rds_cluster.default.id}"
  min_capacity       = var.as_min_size
  max_capacity       = var.as_max_size
}

resource "aws_appautoscaling_policy" "replicas" {
  count              = var.autoscaling_enabled == "true" ? 1 : 0
  name               = "default-autoscaling"
  service_namespace  = aws_appautoscaling_target.replicas[0].service_namespace
  scalable_dimension = aws_appautoscaling_target.replicas[0].scalable_dimension
  resource_id        = aws_appautoscaling_target.replicas[0].resource_id
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type
    }

    target_value       = var.metric_targe_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}
