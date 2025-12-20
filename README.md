
# GCP 3-Tier Production-Style Architecture using Terraform

A brief description of what this project does and who it's for

🚀 GCP 3-Tier Production-Style Architecture using Terraform

📌 Overview

This repository demonstrates a production-style 3-tier architecture on Google Cloud Platform (GCP), fully provisioned using Terraform (Infrastructure as Code).

The focus of this project is realistic cloud design:
- Private networking
- Tiered access control
- Secure ingress with HTTPS
- Application-level routing
- End-to-end data flow (Web → App → DB)

This is not a diagram-only project — every component is deployed, wired, and validated.

🏗️ High-Level Architecture

``` text
Internet
   |
[ External HTTPS Load Balancer ]
   |
[ Web Tier - Private Subnet ]
   |
[ App Tier - Private Subnet ]
   |
[ DB Tier - Private Subnet ]
```

All tiers use private IPs only.
Outbound internet access is handled via Cloud NAT.

🔹 Architecture Components\
🌐 Entry Layer
- GCP External HTTPS Application Load Balancer
- Global static IP
- SSL/TLS certificates generated using Certbot
- Certificates integrated with GCP Certificate Manager
- HTTPS termination at Load Balancer
- HTTP → HTTPS redirection
- Cloud DNS for domain resolution (thehsk.shop)

🖥️ Web Tier (Private Subnet)
- Nginx running as reverse proxy
- Serves UI dashboard
- Displays live GCP instance metadata (/home)
- Proxies API requests to App tier
- No public IP
- Internet access via Cloud NAT

⚙️ Application Tier (Private Subnet)
- Python Flask API served via Gunicorn
- Endpoints:
- /movies
- /songs
- Fetches data only from DB tier
- No public exposure
- Accepts traffic only from Web tier

🗄️ Database Tier (Private Subnet)
- MySQL
- Private IP only
- Access restricted to App subnet
- Stores movies & songs data
- No outbound exposure

🔀 Routing Design (Important)
- Load Balancer acts as the single secure entry point
- Path-based routing is implemented at the Web tier using Nginx
- This is application-level routing, not LB-level URL map routing

✔ Deliberate design choice
✔ Simplifies LB configuration
✔ Mirrors common real-world architectures

🔐 Security & Networking
- Custom VPC (no default network)
- Multiple private subnets
- Strict firewall rules:
- LB → Web (80/443)
- Web → App (8080)
- App → DB (3306)
- No public IPs on Compute instances
- Controlled metadata access
- All outbound traffic via Cloud NAT

🛠️ Tech Stack
- Terraform
- Google Cloud Platform
- VPC
- Compute Engine
- Cloud NAT
- External HTTPS Load Balancer
- Certificate Manager
- Cloud DNS
- Nginx
- Flask + Gunicorn
- MySQL
- Certbot (SSL/TLS)

🌐 Live Functional Endpoints
``` text
/        → UI Dashboard
/home    → Live GCP instance metadata
/movies  → Movie data (DB → App → Web)
/songs   → Song data (DB → App → Web)
```

📂 Repository Structure
```
gcp-terraform-vpc-compute/
├── app-server.tf
├── app-userdata.sh
├── backend-service.tf
├── certificate-map.tf
├── db-instance.tf
├── db-userdata.sh
├── dns.tf
├── firewall.tf
├── forwarding.tf
├── lb-ip.tf
├── nat-gateway.tf
├── providers.tf
├── route.tf
├── subnet.tf
├── variables.tf
├── terraform.tfvars
├── vpc.tf
├── web-instance.tf
├── web-userdata.sh
├── README.md
```
⚙️ Prerequisites
- Google Cloud Project
- Service Account with required IAM permissions
- Terraform CLI (>= 1.5)
- Google Cloud SDK
- Domain name (for HTTPS & DNS)

🔐 Authentication
Service Account–based authentication:
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/sa.json"

🚀 How to Deploy
terraform init
terraform validate
terraform plan
terraform apply

To clean up:
terraform destroy

📖 Key Concepts Demonstrated
- GCP VPC design & subnet isolation
- Firewall rule evaluation & least privilege
- Private service communication
- Cloud NAT for outbound traffic
- HTTPS termination & certificate lifecycle
- Application-level routing with Nginx
- Startup scripts & VM bootstrapping
- Terraform state & reproducibility


🎯 Why This Project Matters
- Demonstrates real cloud networking
- Focuses on security-first design
- Clear separation of concerns
- Avoids unnecessary complexity
- Fully reproducible & auditable via IaC
- Strong foundation for:
- Managed Instance Groups
- Autoscaling
- CI/CD
- Kubernetes & GKE
- Production SRE patterns

👨‍💻 Author

V Hema Siva Kishore
SRE | DevOps | Cloud Automation

🔗 GitHub: https://github.com/hemasivakishore \
🔗 LinkedIn: https://linkedin.com/in/hemasivakishore