# Infra Bootstrap Setup

This repository contains Terraform configurations to bootstrap infrastructure in **AWS** and **Azure**. It helps you quickly provision and manage virtual machines (VMs) and supporting resources using infrastructure as code.

---

## 📁 Folder structure

infra-bootstrap/
├── aws/
│ ├── main.tf
│ └── ...
├── azure/
│ ├── main.tf
│ └── ...
└── .gitignore

---

## ☁️ AWS Setup

### ✅ Prerequisites
- AWS account
- IAM user with programmatic access and permissions to create EC2 and networking resources
- AWS CLI configured (`aws configure`) or credentials saved in `~/.aws/credentials`

### 💻 How to deploy

cd aws
terraform init
terraform plan
terraform apply


☁️ Azure Setup
✅ Prerequisites
Azure account
Azure CLI installed (az login)
Subscription ID (configured in provider block)

### 💻 How to deploy

cd azure
terraform init
terraform plan
terraform apply

### Files to ignore
Sensitive or local files are excluded by .gitignore:

markdown
Copy
Edit
*.tfstate
*.tfstate.backup
.terraform/
*.pem
*.key
terraform.tfvars

#### 💬 Notes
SSH keys are required for accessing VMs; make sure to generate and configure your local SSH keys (~/.ssh/id_rsa.pub) before applying.

VMs are created using minimal-size instances (free tier when possible) for learning and testing purposes. Adjust instance sizes as needed.

Always verify public IP and security group (NSG) rules before exposing SSH to the internet for security.

### ⭐ Contributing
Feel free to fork this repository and contribute improvements (e.g., adding GCP, using modules, setting up remote backend state, etc.).

### 📄 License
This project is for educational and internal use purposes. Update the license as needed.!
