terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

provider "kubernetes" {
  host                   = var.cluster-endpoint
  cluster_ca_certificate = base64decode(var.cluster-certificate-authority-data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args        = ["eks", "get-token", "--cluster-name", var.cluster-name]
  }
}

provider "helm" {
  kubernetes {
    host                   = var.cluster-endpoint
    cluster_ca_certificate = base64decode(var.cluster-certificate-authority-data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args        = ["eks", "get-token", "--cluster-name", var.cluster-name]
    }
  }
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = var.cluster-endpoint
  cluster_ca_certificate  = base64decode(var.cluster-certificate-authority-data)
  load_config_file         = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args        = ["eks", "get-token", "--cluster-name", var.cluster-name]
  }
}