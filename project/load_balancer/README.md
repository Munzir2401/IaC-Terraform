# Dynamic Path-Based Routing & Auto-Scaling on AWS with Terraform

This project uses Terraform to deploy a resilient, scalable, and dynamic web architecture on AWS. It's designed to automatically route traffic based on URL paths (e.g., `/cars`, `/bikes`) to different backend fleets of servers, each capable of auto-scaling independently based on CPU load.

This is a perfect example of an Infrastructure as Code (IaC) setup for a microservices-style application, where different services have different scaling needs.

## Architecture Overview

The architecture is designed for high availability and dynamic scaling. At its core, an Application Load Balancer (ALB) inspects incoming traffic and routes it to the appropriate backend service.

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
```

## Key Features

*   **Dynamic Path-Based Routing:** Add or remove backend services simply by changing a variable, without touching the core code.
*   **Independent Auto-Scaling:** Each service (e.g., "cars", "bikes") has its own Auto Scaling Group that scales based on its unique traffic load.
*   **Immutable Infrastructure:** Uses Launch Templates to define server configurations. Updates are handled by replacing old instances with new ones, not by modifying them in place.
*   **Centralized & Reusable Configuration:** A single, generic Launch Template is used for all services, promoting consistency.
*   **Automated Health Checks:** The ALB and Auto Scaling Groups work together to automatically detect unhealthy instances, terminate them, and launch healthy replacements.

## Prerequisites

Before you begin, ensure you have the following:
1.  An AWS Account.
2.  [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed on your local machine.
3.  AWS CLI installed and configured with your credentials (or environment variables set).

## How to Use

1.  **Clone the Repository:**
    ```bash
    git clone <your-repo-url>
    cd <your-repo-directory>
    ```

2.  **Configure Your Deployment:**
    Create a file named `myvars.tfvars` in the project root. This is where you will define the specific details for your environment. Use the provided `myvars.tfvars` file as a starting point.

    At a minimum, you must provide:
    *   `alb_subnets`: A list of at least two public subnet IDs in different Availability Zones.
    *   `asg_subnets`: A list of subnet IDs where your EC2 instances will be launched (these are often private subnets).
    *   `key_pair_name`: The name of an existing EC2 Key Pair to allow SSH access to the instances.

3.  **Initialize Terraform:**
    Run this command to download the necessary AWS provider plugins.
    ```bash
    terraform init
    ```

4.  **Plan the Deployment:**
    Review the changes Terraform will make to your infrastructure.
    ```bash
    terraform plan -var-file="myvars.tfvars"
    ```

5.  **Apply the Configuration:**
    Build the infrastructure on AWS.
    ```bash
    terraform apply -var-file="myvars.tfvars"
    ```

Once the apply is complete, Terraform will output the DNS name of your load balancer. You can use this URL to access your application.

## Customization

This module is designed to be flexible. Here are the key variables you can customize in your `myvars.tfvars` file:

*   `context_paths`: A map that defines the backend services. The key is the name (e.g., "cars") and the value is the URL path pattern (e.g., "/cars*"). Terraform will automatically create a Target Group and an Auto Scaling Group for each entry.
*   `homepage_asg`: An object to configure the scaling parameters for the default (homepage) fleet.
*   `per_tg_asg_defaults`: An object that defines the *default* scaling parameters for all path-based fleets created from `context_paths`.
*   `per_tg_asg_config`: (Optional) A map that allows you to **override** the default scaling parameters for specific, high-traffic services. For example, you can give your "cars" service a higher `max_size` than the others. See the `variables.tf` file for the structure.

## What's Next?

This project is a living example of learning in public. Future improvements could include:
*   Integrating with a CI/CD pipeline for automated deployments.
*   Adding a database layer (e.g., RDS) with proper security group configurations.
*   Implementing more sophisticated scaling policies based on custom CloudWatch metrics.