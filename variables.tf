

variable "region" {
  description = "Default AWS region, e.g. 'us-west-2' or 'us-east-2'"
  type        = string
}

variable "db_engine" {
  description = "Cluster engine"
  type        = string
  default     = "aurora-postgresql"
}

variable "db_instance_class" {
  description = "The compute and memory capacity of each DB instance in the cluster"
  type        = string
  default     = "db.t3.small"
}

variable "db_instance_count" {
  description = "Number of instances to be created in the cluster"
  type        = number
  default     = 1
}

variable "db_engine_version" {
  description = "The database engine version. Updating this argument results in an outage"
  type        = string
  default     = "13.6"
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately (`true`), or during the next maintenance window (`false`)"
  type        = bool
  default     = true
}

variable "availability_zones" {
  description = "List of Availability Zones for the DB cluster storage where DB cluster instances can be created"
  type        = list(string)
}

variable "performance_insights" {
  description = "Whether to Enable/Disbale Performance Insights"
  type        = bool
  default     = true
}

variable "db_root_user" {
  description = "Username for the master DB user"
  type        = string
  default     = "root"
}


variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = string
  default     = "7"
}

variable "delete_protect" {
  description = "Enable/Disable Delete Protection"
  type        = bool
  default     = true
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created. Time in UTC"
  type        = string
  default     = "08:00-09:00"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "(Conflicts with `db_subnet_group_name`) List of subnets of the subnet group"
  type        = list(string)
  default     = []
}

variable "db_subnet_group_name" {
  description = "(Conflicts with `subnet_ids`) RDS subnet group name"
  type        = string
  default     = ""
}

variable "db_subnet_group_cidr_block" {
  description = "(Conflicts with `subnet_ids`) RDS subnet group CIDR Blocks"
  type        = list(string)
  default     = []
}


variable "sg_cidr_blocks" {
  description = "Additional CIDR Blocks to add in the db security group"
  type        = list(string)
  default     = []
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "postgres"
}

variable "r53_zone_id" {
  description = "Route53 zone ID"
  type        = string
  default     = ""
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "Kms key id for rds cluster encryption"
  type        = string
  default     = ""
}

variable "iam_database_authentication_enabled" {
  description = "Enable or disable IAM authentication for DB"
  type        = string
  default     = "false"
}

variable "snapshot_identifier" {
  description = "ID of the snapshot to be used for database restoration"
  type        = string
  default     = null
}

variable "autoscaling_enabled" {
  description = "Enable or disable cluser autoscaling. Values (`true` | `false`)"
  type        = string
  default     = "false"
}

variable "as_min_size" {
  description = "Minimun number of read replicas"
  type        = number
  default     = 1
}

variable "as_max_size" {
  description = "Maximun number of read replicas"
  type        = number
  default     = 2
}

variable "predefined_metric_type" {
  description = "Metric type to be used to scale the database"
  type        = string
  default     = "RDSReaderAverageCPUUtilization"
}

variable "metric_targe_value" {
  description = "Threshold to scale up/down the database"
  type        = number
  default     = 75
}

variable "scale_in_cooldown" {
  description = "Amount of time, in seconds, after a scale in activity completes before another scale in activity can start"
  type        = number
  default     = 300
}

variable "scale_out_cooldown" {
  description = "Amount of time, in seconds, after a scale out activity completes before another scale out activity can start"
  type        = number
  default     = 300
}
variable "kms_key_arn" {}