# Terraform GCP VPC & Compute Infrastructure

## 📌 Overview
This repository demonstrates **foundational Google Cloud infrastructure** built using **Terraform**, focusing on **networking and compute primitives**.

Instead of jumping directly into advanced pipelines, this project deliberately builds **strong GCP fundamentals** — exactly how real-world cloud environments are designed.

---

## 🏗️ Architecture Components

- Custom VPC (non-default)
- Regional Subnets
- Firewall Rules (Ingress & Egress)
- Compute Engine VM
- Startup Scripts & Metadata
- Service Account attachment
- Terraform best practices

---

## 🧰 Tech Stack

- **Cloud Provider:** Google Cloud Platform (GCP)
- **IaC Tool:** Terraform
- **Resources Used:**
  - google_compute_network
  - google_compute_subnetwork
  - google_compute_firewall
  - google_compute_instance

---

## 🌐 Architecture Flow
```text
Custom VPC
├── Subnet (Regional)
├── Firewall Rules
│   ├── SSH Access
│   ├── HTTP Access
│   └── Internal Traffic
└── Compute Engine VM
```

---

## 📂 Repository Structure
terraform-gcp-vpc-compute/
├── README.md
├── versions.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── vpc.tf
├── subnets.tf
├── firewall.tf
├── compute.tf
├── terraform.tfvars
└── diagrams/
└── gcp-vpc-architecture.png

---

## ⚙️ Prerequisites

- Google Cloud Account
- GCP Service Account with required IAM permissions
- Terraform CLI (>= 1.5)
- Google Cloud SDK (gcloud)

---

## 🔐 Authentication

This project uses **Service Account authentication**.

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"

🚀 How to Use
Initialize Terraform:
```
terraform init
```
Validate configuration:
```
terraform validate
```
Generate execution plan:
```
terraform plan
```
Apply infrastructure:
```
terraform apply
```
Destroy infrastructure:
```
terraform destroy
```

📖 Key Concepts Covered
	•	GCP Global VPC vs Regional Subnets
	•	Firewall Rules and Evaluation Order
	•	Tags vs Service Accounts in Firewall Policies
	•	Compute Engine Metadata & Startup Scripts
	•	Terraform State Management
	•	Infrastructure Reusability and Consistency

🎯 Why This Project

This repository is designed to:
	•	Build strong GCP networking fundamentals
	•	Prepare for cloud and architecture interviews
	•	Act as a base foundation for advanced topics such as:
	•	Cloud NAT
	•	Load Balancers
	•	Managed Instance Groups
	•	Golden Images (Packer)
	•	CI/CD integrations

👨‍💻 Author

V Hema Siva Kishore
SRE | DevOps | Cloud Automation

🔗 LinkedIn: https://linkedin.com/in/hemasivakishore
🔗 GitHub: https://github.com/hemasivakishore
