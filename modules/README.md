# IaC-Terraform

# 🌐 Terraform Modular AWS Infrastructure

This repository contains modular, reusable Terraform code to provision the following AWS resources:

- ✅ S3 bucket (for backend state or general storage)
- ✅ VPC with public and private subnets
- ✅ EC2 instances within the VPC
- ✅ RDS instances within the VPC

All resources are defined using **enterprise-level Terraform modules**, making the setup scalable, clean, and easy to reuse across environments (dev, staging, prod, etc.).

---

## 📁 Project Structure
├── appn
│ ├── main.tf
│ └── providers.tf
└── modules
├── ec2
│ ├── main.tf
│ ├── myvars.tfvars
│ ├── providers.tf
│ └── variables.tf
├── s3
│ ├── main.tf
│ ├── myvars.tfvars
│ ├── providers.tf
│ └── variables.tf
├── vpc
│ ├── main.tf
│ ├── myvars.tfvars
│ ├── outputs.tf
│ ├── providers.tf
│ └── variables.tf
└── rds
├── main.tf
├── myvars.tfvars
├── providers.tf
└── variables.tf
            

### 🔧 Modules

- ../modules/s3/ – Creates an S3 bucket with configurable name and ACL.
- ../modules/vpc/ – Builds a VPC with public and private subnets, internet gateway, route tables, etc.
- ../modules/ec2/ – Launches EC2 instances within subnets (using outputs from the VPC module).
- ../modules/rds/ – Launches RDS instances within subnets (using outputs from the VPC module and role from ec2 module).

---

## ⚙️ How It Works

Each resource is broken into its own module.

 app1 calls the modules with specific values using input variables and `.tfvars` files.

Example:  
```
module "vpc" {
  source     = "../modules/vpc"
  cidr_block = "your-CIDR-value"
  name       = "app1-vpc"
}

module "ec2" {
  source        = "../modules/ec2"
  subnet_id     = module.vpc.public_subnet_id
  security_group = module.vpc.default_sg_id
}
```
⚠️ The Catch: Connecting EC2 to VPC
Since the EC2 instance is launched via a separate module, it doesn't inherently "know" which VPC to belong to.
To solve this:
•	Outputs like public_subnet_id, private_subnet_id, and security_group_id are defined in the VPC module.
•	These are then passed as inputs to the EC2 module.
•	This ensures EC2s are provisioned in the correct network context.
________________________________________
🧪 How to Use
1.	Clone this repo:
git clone https://github.com/Munzir2401/IaC-Terraform.git
cd terraform-aws-infra/projects/app1
2.	Initialize Terraform:
terraform init
3.	Plan the deployment:
terraform plan
4.	Apply the changes:
terraform apply
________________________________________

📌 Next Steps (Work in Progress)
•	Add IAM module (Now Added)
•	Add RDS (Now Added)


