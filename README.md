
# Terraform AWS Infrastructure with GitHub Actions (OIDC)

## 📌 Overview

This project demonstrates a **production-grade DevOps workflow** using **Terraform, AWS, and GitHub Actions**.

The goal is to provision AWS infrastructure in a **secure, repeatable, and automated way**, following **real-world CloudOps / DevOps best practices**, including:

* Modular Terraform design
* Remote state with locking
* Secure CI/CD authentication using **OIDC (no static AWS credentials)**
* Safe deployment workflow (`plan` on PR, `apply` on protected branch only)

This repository is designed as a **portfolio project** suitable for **DevOps / CloudOps / SRE roles**.

---

## 🧱 Architecture

### AWS Infrastructure

* VPC with public subnets
* Internet Gateway and routing
* EC2 instance
* Security Groups
* IAM (for CI/CD access)

### CI/CD

* GitHub Actions
* Terraform CLI
* AWS IAM OIDC federation
* Remote Terraform backend (S3 + DynamoDB)

---

## 📂 Repository Structure

```
terraform-aws-github-actions/
│
├── bootstrap/
│   └── backend/
│       ├── main.tf                 # S3 + DynamoDB backend bootstrap
│       ├── variables.tf
│       └── outputs.tf
│
├── modules/
│   ├── vpc/
│   │   ├── main.tf                 # VPC, subnets, IGW, route tables
│   │   ├── variables.tf            # VPC module inputs
│   │   └── outputs.tf              # VPC outputs (VPC ID, subnet IDs)
│   │
│   └── ec2/
│       ├── main.tf                 # EC2 instance + security group
│       ├── variables.tf            # EC2 module inputs
│       └── outputs.tf              # EC2 outputs (instance ID, public IP)
│
├── envs/
│   └── dev/
│       ├── main.tf                 # Module wiring & provider config
│       ├── backend.tf              # Remote backend configuration
│       ├── variables.tf            # Environment-level variables
│       └── terraform.tfvars        # Dev environment values
│
├── iam/
│   └── github-actions/
│       ├── oidc.tf                 # GitHub OIDC identity provider
│       ├── iam-role.tf             # IAM role with OIDC trust policy
│       ├── iam-policy.tf           # IAM permissions for Terraform
│       ├── variables.tf            # Inputs (repo, branch, role name, etc.)
│       └── outputs.tf              # Outputs (IAM role ARN, OIDC provider ARN)
│
├── .github/
│   └── workflows/
│       └── terraform.yml           # GitHub Actions CI/CD pipeline
│
└── README.md
```

---

## 🔐 Security Design (Key Highlight)

### 1️⃣ No AWS Access Keys in CI/CD

* GitHub Actions authenticates to AWS using **OIDC**
* No long-lived credentials
* AWS issues **short-lived STS credentials** at runtime

### 2️⃣ IAM Trust Policy Hardening

The IAM role used by GitHub Actions is restricted by:

* Repository (`owner/repo`)
* Branch (`master` only for apply)
* Event type (PR vs push)

This ensures:

* `terraform plan` runs on pull requests
* `terraform apply` runs **only** on the protected branch
* Manual or malicious runs from other branches are blocked at the AWS IAM level

### 3️⃣ Defense in Depth

Security is enforced at multiple layers:

* IAM trust policy (OIDC claims)
* GitHub Actions workflow logic
* Branch protection rules
* Terraform remote state locking

---

## 🔁 Terraform & IAM Bootstrap Strategy

Terraform and CI/CD authentication both have a **bootstrapping requirement**.

This project uses a **two-phase bootstrap pattern** to handle this safely and correctly.

---

### Phase 1: Bootstrap Infrastructure (Run Locally)

The following resources **must exist before CI/CD can run**:

#### 🔹 Terraform Backend

* S3 bucket for remote state
* DynamoDB table for state locking

#### 🔹 CI/CD Identity (OIDC)

* GitHub OIDC identity provider
* IAM role for GitHub Actions
* IAM policy attached to the role

These resources are created using **local Terraform execution** and **local state**.

Locations:

```
bootstrap/backend        # S3 + DynamoDB
iam/github-actions       # OIDC provider, IAM role, IAM policy
```

Example:

```bash
cd bootstrap/backend
terraform init
terraform apply

cd ../../iam/github-actions
terraform init
terraform apply
```

> These steps are executed **once** and are not part of the CI/CD pipeline.

---

### Phase 2: Application Infrastructure (CI/CD Managed)

After the backend and OIDC IAM resources exist:

* Terraform in `envs/dev` uses:

  * Remote S3 backend
  * DynamoDB state locking
* GitHub Actions authenticates to AWS using OIDC
* No AWS access keys are stored in GitHub

Location:

```
envs/dev
```

CI/CD now safely runs:

* `terraform plan` on pull requests
* `terraform apply` only on the protected branch

---

## 🚀 CI/CD Workflow

### Pull Requests

* Triggered on PR to protected branch
* Runs:

  * `terraform init`
  * `terraform validate`
  * `terraform plan`
* No infrastructure changes applied

### Protected Branch (master)

* Triggered on push or manual dispatch
* Runs:

  * `terraform init`
  * `terraform apply`
* Infrastructure changes are applied safely

---

## 🧪 How to Run (High Level)

### Prerequisites

* AWS account
* Terraform installed locally
* GitHub repository with Actions enabled

### 1️⃣ Bootstrap Backend

```bash
cd bootstrap/backend
terraform init
terraform apply
```

### 2️⃣ Configure IAM OIDC Role

```bash
cd iam/github-actions
terraform init
terraform apply
```

### 3️⃣ Push Code / Open PR

* GitHub Actions pipeline runs automatically
* No AWS credentials required in GitHub Secrets

---

## 🧠 Key Design Decisions

* **Modules over monolithic Terraform** → reusability and clarity
* **Remote state with locking** → safe concurrent execution
* **OIDC over access keys** → modern AWS security best practice
* **Branch-level IAM enforcement** → protection beyond CI logic
* **Single environment (dev)** → focused, interview-ready scope

---
