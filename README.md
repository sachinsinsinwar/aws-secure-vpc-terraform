# AWS Secure VPC - Terraform Project

This project builds a secure AWS VPC using Terraform as part of my cloud security learning path.


It includes:

- A dedicated VPC
- Public and private subnets
- Internet Gateway and NAT Gateway
- Route tables and security groups
- Application Load Balancer (ALB)
- Encrypted S3 bucket for logs
- GuardDuty for threat detection (configured in AWS)

All infrastructure changes are defined as code using Terraform.

Architecture Overview

This Terraform project sets up a small AWS environment for learning and testing cloud security concepts.
It includes the following components:

VPC and Networking

 - VPC with CIDR 10.0.0.0/16

 - One public subnet in ap-south-1a and one in ap-south-1b

 - One private subnet in ap-south-1a

 - Internet Gateway attached to the VPC
 
 - NAT Gateway in the public subnet for outbound access from private resources

Load Balancer

 - Internet-facing Application Load Balancer (ALB)

 - Deployed across two public subnets

 - ALB security group allows HTTP (80) from anywhere

Private EC2 Instance

 - Ubuntu 22.04 instance placed only in the private subnet

 - No public IP assigned

 - Nginx installed through user data and serves a simple test page

 - EC2 security group:

     - Allows HTTP only from the ALB

     - Outbound allowed only for ports 80/443 (for package updates)

Routing

 - Public route table sends 0.0.0.0/0 to the Internet Gateway

 - Private route table sends 0.0.0.0/0 to the NAT Gateway

Notes

 - All resources are tagged for easy identification.

 - The goal is to keep the EC2 instance fully private and reachable only through the ALB. 
