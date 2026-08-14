# Terraform Azure Landing Zone

A reusable **Azure infrastructure project built with Terraform**, designed to provision Azure resources through modular Terraform configurations and GitHub Actions CI/CD.

The project focuses on making infrastructure **reusable, environment-specific, maintainable, and suitable for automated deployment**.

## 🏗️ Architecture

The infrastructure follows a modular structure where Azure resources are separated into reusable Terraform modules.

```text
Azure
│
├── Resource Group
│
├── Virtual Network
│   │
│   ├── Subnet
│   │   ├── NIC
│   │   └── Virtual Machine
│   │
│   └── Subnet
│
├── Network Security Group
│   └── Security Rules
│
├── Public IP
│
└── Storage Account
    └── Terraform Remote State
```

## 📁 Repository Structure

```text
.
├── .github/
│   └── workflows/
│       ├── terraform-feature-branch.yml
│       └── terraform-main-deploy.yaml
│
├── environment/
│   ├── dev/
│   ├── test/
│   └── prod/
│
├── module/
│   ├── azurerm_bastion_group/
│   ├── azurerm_container_group/
│   ├── azurerm_network_interface_security_group_association/
│   ├── azurerm_network_security_group/
│   ├── azurerm_nic_group/
│   ├── azurerm_public_ip/
│   ├── azurerm_resource_group/
│   ├── azurerm_storage_account_group/
│   ├── azurerm_subnet_group/
│   ├── azurerm_virtual_machine_group/
│   └── azurerm_vnet_group/
│
├── .gitignore
└── README.md
```

The repository currently separates reusable modules from environment-specific configurations for **dev, test, and prod**.

## 🚀 Key Features

### Terraform Modules

Azure resources are organized into reusable modules instead of keeping everything in a single Terraform configuration.

This makes it easier to:

- Reuse infrastructure components
- Maintain resources independently
- Add new environments
- Reduce duplicated Terraform code

### Environment-Based Configuration

Separate environment directories are used for:

- `dev`
- `test`
- `prod`

This allows the same reusable modules to be configured differently depending on the environment.

### Generic Terraform Configuration

The infrastructure uses variables and `tfvars` files to avoid hardcoding environment-specific values.

Examples include:

- Resource names
- Locations
- VM configuration
- VNet configuration
- Subnets
- NSG rules
- Public IP configuration

### Remote Terraform State

The project is designed to use an **Azure Storage Account for Terraform remote state**.

> **Important:** The backend storage account needs to exist before Terraform can initialize and use it as the backend. This creates a bootstrap dependency when the storage account itself is managed by Terraform.

## 🔐 GitHub Actions + Azure Authentication

The project includes GitHub Actions workflows for Terraform automation.

Current workflows include:

```text
Pull Request / Feature Branch
        │
        ▼
Terraform validation / plan
```

and:

```text
main
 │
 ▼
Terraform deployment
```

The repository uses the Azure/GitHub **OIDC + Workload Identity Federation** approach so GitHub Actions can authenticate to Azure without relying on long-lived Azure client secrets.

## 🔄 CI/CD Flow

```text
Developer
    │
    ▼
Feature Branch
    │
    ▼
Pull Request
    │
    ▼
GitHub Actions
    │
    ├── Terraform Init
    ├── Terraform Validate
    ├── Terraform Plan
    │
    ▼
Merge to main
    │
    ▼
GitHub Actions
    │
    ├── Terraform Init
    ├── Terraform Plan
    └── Terraform Apply
    │
    ▼
Azure Infrastructure
```

The repository contains dedicated workflows for feature branches and main-branch deployment.

## 🛠️ Technologies Used

- **Terraform**
- **Microsoft Azure**
- **GitHub Actions**
- **Azure Storage**
- **Azure Virtual Network**
- **Azure Subnets**
- **Azure Network Security Groups**
- **Azure Virtual Machines**
- **Azure Network Interfaces**
- **Azure Public IP**
- **OIDC / Workload Identity Federation**

## ⚙️ Getting Started

### Prerequisites

Install and configure:

- Terraform
- Azure CLI
- Git
- An Azure subscription
- Appropriate Azure permissions

Verify Terraform:

```bash
terraform version
```

Verify Azure CLI:

```bash
az version
```

Login to Azure:

```bash
az login
```

Select the required subscription:

```bash
az account set --subscription "<SUBSCRIPTION_ID>"
```

## 📦 Initialize Terraform

Navigate to the required environment:

```bash
cd environment/dev
```

Initialize Terraform:

```bash
terraform init
```

## 🔍 Validate Configuration

```bash
terraform validate
```

## 📋 Review the Plan

```bash
terraform plan
```

## 🚀 Deploy Infrastructure

```bash
terraform apply
```

To automatically approve:

```bash
terraform apply -auto-approve
```

## 🧹 Destroy Infrastructure

When the environment is no longer required:

```bash
terraform destroy
```

> Be careful when running `terraform destroy`, especially against shared or production environments.

## 💡 Design Considerations

This project was also an exercise in understanding the difference between **making Terraform work** and **designing Terraform properly**.

Some of the main challenges explored during development were:

### 1. Backend Bootstrap

Terraform initializes the backend before managing resources, so the remote-state Storage Account introduces a bootstrap problem.

### 2. Module Design

A module should expose the configuration that actually needs to vary without creating unnecessary complexity.

### 3. Terraform Types

Understanding the difference between:

```text
map
list
set
object
```

is important when designing reusable `tfvars` structures.

### 4. `for_each` and Dynamic Infrastructure

`for_each` is used to create multiple similar resources from structured configuration rather than duplicating resource blocks.

### 5. Cost Awareness

Terraform makes infrastructure deployment repeatable, but **repeatability does not automatically mean cost optimization**.

VM SKUs, disks, networking components and other Azure resources should be selected according to the actual workload and requirements.

## 📚 What I Learned

Building this project helped me understand that Terraform is not only about writing HCL.

The bigger engineering challenges are:

- Designing reusable modules
- Structuring variables properly
- Managing remote state
- Bootstrapping infrastructure
- Managing multiple environments
- Designing CI/CD workflows
- Securing GitHub-to-Azure authentication
- Understanding Azure resource dependencies
- Making infrastructure cost-aware

## ⚠️ Important Notes

This repository is primarily a **learning and hands-on infrastructure project**.

Before using a similar architecture in production, consider adding:

- State locking and recovery strategy
- Environment protection rules
- Azure RBAC with least privilege
- Approval gates for production
- Terraform plan artifacts
- Secret management where required
- Policy enforcement
- Cost controls
- Monitoring and logging
- Security scanning
- Infrastructure testing

## 🤝 Feedback

This project is continuously evolving.

If you have experience with **Terraform, Azure, or DevOps**, feedback is welcome—especially around:

- Terraform module design
- Remote state architecture
- `tfvars` structure
- GitHub Actions workflows
- Azure security
- Cost optimization

## 👨‍💻 Author

**Nikheel Kumar**

GitHub: [19Nikheel](https://github.com/19Nikheel)

---

⭐ If you find this project useful or have suggestions for improvement, feel free to explore the repository and share your feedback.
