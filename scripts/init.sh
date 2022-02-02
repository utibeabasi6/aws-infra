#!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install nginx1.12
sudo systemctl start nginx