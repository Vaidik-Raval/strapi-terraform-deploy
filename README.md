# 🚀 Strapi Deployment & CI/CD Pipeline with Terraform + GitHub Actions  

This repository demonstrates the **deployment of a Strapi application on AWS ECS Fargate** with full **infrastructure automation via Terraform**, and a **CI/CD pipeline built with GitHub Actions** for seamless containerized deployments.  

---

## 📂 Project Overview  

### **1. Strapi Deployment with Terraform**  
- **Tools/Tech:** AWS, Terraform, ECS Fargate, DockerHub  
- **Highlights:**  
  - Automated deployment of Strapi using **Terraform**.  
  - Provisioned **ECS Fargate Cluster**, **IAM roles**, and **Application Load Balancer (ALB)**.  
  - Terraform pulls the latest Docker image from **DockerHub**.  

---

### **2. CI/CD Pipeline with GitHub Actions**  
- **Tools/Tech:** GitHub Actions, Docker, DockerHub, ECS  
- **Highlights:**  
  - Automated **build, test, and push pipeline** using GitHub Actions.  
  - **Dockerized Strapi application** pushed to **DockerHub**.  
  - Deployment is triggered by running `terraform apply`.  
  - Secure handling of DockerHub credentials using GitHub Secrets.  

---

## ⚙️ Architecture  

```
                ┌───────────────┐
                │   GitHub Repo │
                └───────┬───────┘
                        │
                        ▼
             ┌─────────────────────┐
             │ GitHub Actions CI/CD│
             └─────────┬──────────┘
                       │ (Build & Push Docker Image)
                       ▼
             ┌─────────────────────┐
             │     DockerHub       │
             └─────────┬──────────┘
                       │ (terraform apply pulls image)
                       ▼
         ┌────────────────────────────┐
         │  AWS ECS Fargate Cluster   │
         │  (Terraform Provisioned)   │
         └──────────────┬─────────────┘
                        │
                        ▼
             ┌─────────────────────┐
             │ Application Load Bal │
             │  (Routes traffic)    │
             └─────────────────────┘
```

---

## 📑 Folder Structure  

```
├── strapi-app/              # Strapi application (Dockerized)
├── terraform/               # Terraform IaC for ECS, ALB, IAM
├── .github/workflows/       # GitHub Actions CI/CD pipelines
├── strapi-app/Dockerfile               # Container setup for Strapi
├── README.md                # Project Documentation
└── ...
```

---

## 🚀 Getting Started  

### **1. Clone Repository**
```bash
git clone[ https://github.com/Vaidik-Raval/strapi-terraform-deploy.git
```

### **2. Setup Environment Variables**  
Create a `.env` file inside `strapi-app/`:
```bash
DATABASE_CLIENT=sqlite
JWT_SECRET=your-secret-key
APP_KEYS=your-app-keys
```

For GitHub Actions (`Settings > Secrets and variables > Actions`), add:  
- `DOCKER_USERNAME`  
- `DOCKER_PASSWORD`  
- `AWS_ACCESS_KEY_ID`  
- `AWS_SECRET_ACCESS_KEY`  
- `AWS_REGION`  

---

### **3. Deploy Infrastructure (Terraform)**  
```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

Terraform will:  
- Pull the latest Strapi Docker image from **DockerHub**  
- Deploy to **ECS Fargate**  
- Attach ALB for routing  

---

### **4. CI/CD Workflow**  
- On **push to `main` branch**:  
  1. Docker image is built.  
  2. Image is pushed to **DockerHub**.  
- To deploy the new version, run:  
  ```bash
  terraform apply -auto-approve
  ```

---

## 🌟 Key Features  
✅ Fully automated **Strapi deployment on AWS ECS Fargate**  
✅ **Infrastructure as Code (IaC)** with Terraform  
✅ **CI/CD with GitHub Actions + DockerHub**  
✅ **Scalable & fault-tolerant** architecture with ALB integration  

---

## 📌 Future Improvements  
- Automate deployment trigger (Terraform Cloud or GitHub Actions Terraform step).  
- Add **Blue/Green Deployment** with AWS CodeDeploy.  
- Set up **Monitoring & Logging** (CloudWatch, Grafana, Prometheus).  
- Multi-environment support (dev/staging/prod).  

---

## 🏷️ Tech Stack  
- **Strapi** (Headless CMS)  
- **Terraform** (Infrastructure as Code)  
- **AWS ECS Fargate** (Serverless containers)  
- **DockerHub** (Container registry)  
- **GitHub Actions** (CI/CD)  
- **Docker** (Containerization)  

---
## 📜 License  
MIT License © 2025  
