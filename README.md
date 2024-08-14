Amazon DB cluster consists of one or more DB instances and a cluster volume that manages the data for those DB instances. An Aurora cluster volume is a virtual database storage volume that spans multiple Availability Zones, with each Availability Zone having a copy of the DB cluster data. Two types of DB instances make up an Aurora DB cluster: DB instance and replica. 
In this project, the aws_rds_cluster resource creates a cluster with 1 instance. It also enables autoscaling to the rds.
Adds, security group rules to the db and adds below values to ssm

db host: /rds-aurora-cluster/db/host
db readonly host: /rds-aurora-cluster/db/ro/host
db root user: /rds-aurora-cluster/db/user
db root password: /rds-aurora-cluster/db/password
database name: /rds-aurora-cluster/db/database
db port: /rds-aurora-cluster/db/port
