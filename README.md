# Simetrik Cloud Engineer Technical Test - Hortencia Santos

Welcome to my solution for the Simetrik Cloud Engineer technical test. This repository is structured to provide a clear overview of the applications, the infrastructure as code, and all supporting materials.

Here's a breakdown of what you'll find:

- **[Applications](./timezone_converter_grpc/):** This directory contains the two Python applications built with the gRPC protocol. You'll find both the `server` and `client` code here. The code is created to work on the AWS infrastructure so it won't run locally (I have a copy that does, in case you're interested in some hard core mega programming)
- **[Terraform Modules](./terraform/modules/):** Here you can find the two reusable required Terraform modules I created. The `networking` module sets up the VPC and subnets, while the `eks` module handles the deployment of the EKS cluster, CI/CD pipeline, and all related resources. There's also a third module, `ec2`, that I used to deploy the client side application to test the server app. 
- **[Terraform Deployments](./terraform/):** I decided to separate each deployment to maintain the state locally for tests purposes. The names are pretty intuitive. 
- **[Scripts](./scripts/):** To meet the requirement of using an Application Load Balancer, I created a script (not in plural, sadly) to install the `aws-load-balancer-controller` inside the EKS cluster. You can find it in this directory.
- **[Deliverables](./deliverables/):** All the required deliverables, including the architecture diagram and the documentation in PDF format, are located here.

