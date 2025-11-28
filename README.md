AWS Secure VPC — Terraform Project

This repository contains a hands-on implementation of a secure AWS networking setup built entirely with Terraform.
The goal of this project is to design and deploy a production-style VPC layout while reinforcing core cloud security concepts such as network isolation, least privilege, controlled egress, and secure load balancing.

The environment includes a fully private EC2 instance reachable only through an Application Load Balancer, along with properly segmented subnets, routing, and security groups. Everything is provisioned as Infrastructure-as-Code to ensure consistency, visibility, and repeatability.

What this project demonstrates

End-to-end VPC design using Terraform

Segregation of public and private subnets across Availability Zones

Secure outbound access from private workloads via a NAT Gateway

Internet-facing ALB with restricted backend communication

Privately hosted Ubuntu EC2 running Nginx (no public exposure)

Strict security group rules for ingress and egress

Use of AWS-managed services like GuardDuty, S3 (for logs), and IAM roles

Clear tagging and structure for easy auditing and cost tracking

This setup reflects real-world patterns commonly used in secure cloud environments and is suitable for learning, demonstrations, portfolio building, or as a starting point for more advanced security automation.

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
