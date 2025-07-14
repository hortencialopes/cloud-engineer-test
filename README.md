# Simetrik Cloud Engineer Technical Test - Hortencia Santos

Welcome to my solution for the Simetrik Cloud Engineer technical test. This repository is structured to provide a clear overview of the applications, the infrastructure as code, and all supporting materials.

Here's a breakdown of what you'll find:

- **[Applications](./timezone_converter_grpc/):** This directory contains the two Python applications built with the gRPC protocol. You'll find both the `server` and `client` code here. The code is created to work on the AWS infrastructure so it won't run locally (I have a copy that does, in case you're interested in some hard core mega programming)
- **[Terraform Modules](./terraform/modules/):** Here you can find the two reusable required Terraform modules I created. The `networking` module sets up the VPC and subnets, while the `eks` module handles the deployment of the EKS cluster, CI/CD pipeline, and all related resources. There's also a third module, `ec2`, that I used to deploy the client side application to test the server app. 
- **[Terraform Deployments](./terraform/):** I decided to separate each deployment to maintain the state locally for tests purposes. The names are pretty intuitive. 
- **[Scripts](./scripts/):** To meet the requirement of using an Application Load Balancer, I created a script (not in plural, sadly) to install the `aws-load-balancer-controller` inside the EKS cluster. You can find it in this directory.
- **[Deliverables](./deliverables/):** All the required deliverables, including the architecture diagram and the documentation in PDF format, are located here.

---

## Table of Contents

EDIT EDIT EDIT EDIT
- [Project Overview](#project-overview)
- [Architecture Diagram](#architecture-diagram)
- [Networking Explanation](#networking-explanation)
- [Deployment Guide](#deployment-guide)
  - [Prerequisites](#prerequisites)
  - [Deploying the Infrastructure](#deploying-the-infrastructure)
  - [Deploying the Application](#deploying-the-application)
  - [Testing the Application](#testing-the-application)
- [Destroying the Infrastructure](#destroying-the-infrastructure)

---

## Project Overview

The goal of this project is to deploy a containerized gRPC server application onto a secure and scalable EKS cluster. The entire infrastructure is defined as code using reusable Terraform modules, and the application deployment is fully automated via a CI/CD pipeline using AWS CodeBuild.

**Key Features:**
- **Infrastructure as Code (IaC):** All AWS resources are managed by Terraform, ensuring repeatability and version control. 
- **title to highlight state preservation** The state of the infrastructure deployed is preserved in remotely in S3 buckets
- **Reusable Modules:** The infrastructure is split into a `networking` module and an `eks` module for maximum reusability across different environments - you can reuse the `ec2` module if you want also.
- **Containerization:** The application is containerized with Docker and stored in a secure AWS ECR repository.
- **Kubernetes Orchestration:** Amazon EKS is used to manage, scale, and ensure the high availability of the application.
- **CI/CD Automation:** A CodeBuild pipeline automatically builds and deploys the application to EKS upon every push to the `main` branch.
- **Secure Exposure:** The application is securely exposed to the internet via an Application Load Balancer (ALB) using an HTTPS listener and a TLS certificate managed by ACM.

---
