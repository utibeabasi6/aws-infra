provider aws {
    profile = "default"
    region = var.aws_region
}

resource "aws_vpc" "infra-vpc" {
  cidr_block = var.vpc_cider

  tags = {
    Name = "Infra VPC"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.infra-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Infra RT"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.infra-vpc.id
  tags = {
    Name = "Infra GW"
  }
}


resource aws_subnet "public"{
    count = 3
    vpc_id     = aws_vpc.infra-vpc.id
   cidr_block = element(var.public_subnet_ciders, count.index)
    availability_zone = element(var.aws_azs, count.index)
  map_public_ip_on_launch = true

    tags = {
        Name = "Infra-Public-Subnet-${count.index + 1}"
    }
}

resource "aws_route_table_association" "rta" {
    count = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rt.id
}

resource aws_subnet "private"{
    count = 3
    vpc_id     = aws_vpc.infra-vpc.id
   cidr_block = element(var.private_subnet_ciders, count.index)
    availability_zone = element(var.aws_azs, count.index)

    tags = {
        Name = "Infra-Private-Subnet-${count.index}"
    }
}

resource aws_subnet "database"{
    count = 3
    vpc_id     = aws_vpc.infra-vpc.id
   cidr_block = element(var.database_subnet_ciders, count.index)
    availability_zone = element(var.aws_azs, count.index)

    tags = {
        Name = "Infra-Database-Subnet-${count.index}"
    }
}

resource "aws_security_group" "http_traffic" {
  name        = "allow_http"
  description = "Allow http traffic"
  vpc_id      = aws_vpc.infra-vpc.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Allow HTTP"
  }
}



resource "aws_instance" "lamp-server" {
  count = var.aws_instance_count
  ami           = var.aws_instance_ami # us-west-2
  instance_type = var.aws_instance_type
  subnet_id = aws_subnet.public[count.index].id
#   key_name = "tableau"
  user_data = "${file("scripts/init.sh")}"
  security_groups = [aws_security_group.http_traffic.id]
  tags = {
    "Name" = "LAMP-Server-${count.index + 1}"
  }
}

resource "aws_elasticache_cluster" "elasticache" {
  cluster_id           = var.elasticache_cluster_id
  engine               = "memcached"
  node_type            = var.elasticache_cluster_node_type
  num_cache_nodes      = var.elasticache_num_cache_nodes
  parameter_group_name = "default.memcached1.4"
  port                 = 11211
  security_group_ids = [aws_subnet.private[0].id]
}

resource "aws_rds_cluster" "rds" {
  cluster_identifier      = var.rds_cluster_identifier
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.03.2"
  availability_zones      = var.aws_azs
  database_name           = var.rds_db_name
  master_username         = var.rds_username
  master_password         = var.rds_password
  backup_retention_period = var.rds_backup_retention
  preferred_backup_window = var.rds_backup_window
}
