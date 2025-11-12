Terraform Modular AWS Infrastructure with Dynamic Load Balancing & Auto Scaling

This repository contains a complete, modular, and production-grade Terraform setup for provisioning AWS infrastructure - from foundational networking (VPC, EC2, RDS, S3, IAM) to advanced path-based routing and auto-scaling using an Application Load Balancer (ALB).

It’s designed for scalability, reusability, and clarity - ideal for both learning and real-world deployment.

Architecture Overview

The architecture is built using independent, reusable Terraform modules.
Each module defines one major AWS service, making the setup flexible and easy to extend.

Core Modules:

VPC Module - Creates a VPC with public & private subnets, route tables, and Internet Gateway.

S3 Module - Provisions S3 buckets (for backend state or general storage).

EC2 Module - Launches EC2 instances in specified subnets

RDS Module - Deploys RDS instances within the VPC.

IAM Module - Manages roles and policies required for other resources.

Advanced Module:

Load Balancer Module (ALB + Auto Scaling) -
Handles path-based routing, auto-healing, and CPU-driven auto scaling for multiple services (like /cars, /bikes, etc.) behind a single ALB.

```
[ User Traffic ]
       |
       v
[ AWS Application Load Balancer ]
       |
       +--> [ Listener Rule: /cars* ] --> [ "Cars" Target Group ] --> [ "Cars" Auto Scaling Group (EC2s) ]
       |
       +--> [ Listener Rule: /bikes* ] --> [ "Bikes" Target Group ] --> [ "Bikes" Auto Scaling Group (EC2s) ]
       |
       +--> [ Default Action ] --------> [ "Homepage" Target Group ] -> [ "Homepage" Auto Scaling Group (EC2s) ]
       |
       +--> (Private Subnets, Databases, etc.)
```
This setup simulates a microservices-like architecture, where each service (e.g., /cars, /bikes) has:

Its own Auto Scaling Group (ASG)

Independent CPU-based scaling policy

Dedicated Target Group behind the ALB

```
├── appn
│   ├── main.tf
│   └── providers.tf
│   └── variables.tf
│   └── outputs.tf
└── modules
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
	│   ├── outputs.tf 
    ├── s3/
    │   ├── main.tf
    │   ├── variables.tf
    ├── s3_log_bucket/
    │   ├── main.tf
    │   ├── variables.tf
	│   ├── outputs.tf
    ├── ec2/
    │   ├── main.tf
    │   ├── variables.tf
    ├── rds/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── secrets.tf
	│   ├── password.tf
	│   ├── iam.tf
	│   ├── data.tf
	│   ├── createusers.sql
	│   ├── auth.sh
    └── load_balancer/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
```
How It Works

Network Foundation:
The VPC module creates isolated public and private subnets with the required route tables and gateways.

Compute Layer:
EC2 instances are deployed within the subnets using Launch Templates that define their configuration (AMI, user data, instance type, etc.).

Storage Layer:
S3 and RDS modules handle object storage and relational databases.

IAM Integration:
IAM roles and policies allow secure interactions between services.

Load Balancing & Auto Scaling:

An Application Load Balancer inspects each request’s path.

Routes traffic to the correct Target Group (e.g., /cars -> Cars ASG).

Each ASG scales dynamically based on its average CPU utilization.

Instances use a bootstrap script (user data) that installs Nginx and serves a unique web page for each path.

How to Deploy
1️ Clone the repository
```
git clone https://github.com/Munzir2401/IaC-Terraform.git
cd IaC-Terraform/appn
```
2️ Configure your environment

In each module or in your main project directory, create a .tfvars file.
At minimum, define:
```
alb_subnets  = ["subnet-abc123", "subnet-def456"]
asg_subnets  = ["subnet-xyz123", "subnet-uvw456"]
key_pair_name = "my-keypair"
```
3️ Initialize Terraform
```
terraform init
```
4️ Plan your deployment
```
terraform plan
```
5️ Apply to build infrastructure
```
terraform apply
```
After successful deployment, Terraform outputs your ALB DNS name.
Visit:
```
http://<alb-dns-name>/
http://<alb-dns-name>/cars
http://<alb-dns-name>/bikes
```
Each path routes to its respective backend EC2 fleet.

Customizing Path-Based Routing

You can easily add or remove backend services by editing your variable file:
```
context_paths = {
  cars  = "/cars*"
  bikes = "/bikes*"
  trucks = "/trucks*"
}
```
Terraform automatically creates the required Target Groups, Listener Rules, and Auto Scaling Groups for each entry.

Auto Scaling Behavior

Each backend fleet is independently scalable based on CPU utilization:

CloudWatch monitors average CPU across instances in the ASG.

When CPU exceeds the threshold (e.g., 40%), ASG scales out.

When CPU remains low, ASG scales back in.

You can manually trigger scaling for testing:
```
stress --cpu 2 --timeout 600
```
CloudWatch logs and scaling activities can be observed in the AWS Console:

EC2 -> Auto Scaling Groups -> Activity

CloudWatch -> Alarms -> Triggered Alarms
```
| Category       | Technology                      |
| -------------- | ------------------------------- |
| IaC            | Terraform                       |
| Cloud Provider | AWS                             |
| Compute        | EC2 + Auto Scaling              |
| Networking     | VPC, Subnets, Internet Gateway  |
| Load Balancing | Application Load Balancer (ALB) |
| Storage        | S3, RDS                         |
| Monitoring     | CloudWatch                      |
| Web Server     | Nginx                           |
```
Future Enhancements

Add CI/CD pipeline integration (e.g., Jenkins or GitHub Actions)

Introduce Blue-Green / Rolling Deployment strategies

Extend monitoring with custom CloudWatch metrics

Add centralized logging with CloudWatch Logs

Summary

This repository demonstrates:

Modular Infrastructure as Code using Terraform

Full AWS stack: VPC, EC2, RDS, S3, IAM, and ALB

Dynamic routing and auto-scaling per microservice path

A clean, extensible foundation for any scalable cloud application

Build once, reuse everywhere — true DevOps practice in action.
