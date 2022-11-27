resource "aws_security_group" "default" {
  name_prefix = "${var.namespace}"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Redis Port"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name       = "${var.namespace}-cache-subnet"
  subnet_ids = ["${aws_subnet.default[0].id}"]
}

# resource "aws_elasticache_cluster" "example" {
#   cluster_id           = "cluster-example"
#   engine               = "redis"
#   node_type            = "cache.t4g.micro"
#   num_cache_nodes      = 1
#   parameter_group_name = "default.redis7"
#   engine_version       = "7.0"
#   port                 = 6379
#   subnet_group_name          = "${aws_elasticache_subnet_group.default.name}"
#   security_group_ids   = ["${aws_security_group.default.id}"]
#   # num_node_groups         = 1
#   # replicas_per_node_group = 1
# }

# resource "aws_elasticache_replication_group" "example" {
#   automatic_failover_enabled  = true
#   replication_group_id        = "tf-rep-group-1"
#   description                 = "example description"
#   node_type                   = "cache.t4g.micro"
#   num_cache_clusters          = 1
#   parameter_group_name = "default.redis7"
#   engine_version       = "7.0"
#   port                        = 6379
# }

# resource "aws_elasticache_cluster" "replica" {
#   cluster_id           = "cluster-example"
#   replication_group_id = aws_elasticache_replication_group.example.id
# }



resource "aws_elasticache_replication_group" "default" {
  replication_group_id          = "${var.cluster_id}"
  description = "Redis cluster for Hashicorp ElastiCache example"
  # num_cache_clusters          = 2 # for cluster disabled setup replicas
  node_type            = "cache.t4g.micro"
  port                 = 6379
  parameter_group_name = "default.redis7.cluster.on"
  # parameter_group_name = "default.redis7"
  security_group_ids   = ["${aws_security_group.default.id}"]
  # snapshot_retention_limit = 5
  # snapshot_window          = "00:00-05:00"

  subnet_group_name          = "${aws_elasticache_subnet_group.default.name}"
  automatic_failover_enabled = true

  replicas_per_node_group = 1
  num_node_groups         = 1

}
