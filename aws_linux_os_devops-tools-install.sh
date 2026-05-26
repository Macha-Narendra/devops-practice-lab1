#!/bin/bash

# =========================================================
# DevOps Tools Auto Installer for Amazon Linux
# Installs:
#   - Terraform
#   - AWS CLI v2
#   - kubectl
#   - eksctl
#   - Helm
# =========================================================

set -e

echo "=================================================="
echo " Updating System Packages"
echo "=================================================="

sudo yum update -y --allowerasing

echo "=================================================="
echo " Installing Required Dependencies"
echo "=================================================="

sudo yum install -y \
    curl \
    unzip \
    wget \
    git \
    gnupg2 \
    tar \
    gzip \
    bash-completion \
    --allowerasing

# =========================================================
# TERRAFORM INSTALLATION
# =========================================================

echo "=================================================="
echo " Installing Terraform"
echo "=================================================="

sudo yum install -y yum-utils --allowerasing

sudo yum-config-manager --add-repo \
https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

sudo yum install -y terraform --allowerasing

# =========================================================
# AWS CLI INSTALLATION
# =========================================================

echo "=================================================="
echo " Installing AWS CLI v2"
echo "=================================================="

cd /tmp

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o "awscliv2.zip"

unzip -o awscliv2.zip

sudo ./aws/install --update

# =========================================================
# KUBECTL INSTALLATION
# =========================================================

echo "=================================================="
echo " Installing kubectl"
echo "=================================================="

KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

curl -LO \
"https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

chmod +x kubectl

sudo mv kubectl /usr/local/bin/

# =========================================================
# EKSCTL INSTALLATION
# =========================================================

echo "=================================================="
echo " Installing eksctl"
echo "=================================================="

ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO \
"https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${PLATFORM}.tar.gz"

tar -xzf eksctl_${PLATFORM}.tar.gz -C /tmp

sudo mv /tmp/eksctl /usr/local/bin

rm -f eksctl_${PLATFORM}.tar.gz

# =========================================================
# HELM INSTALLATION
# =========================================================

echo "=================================================="
echo " Installing Helm"
echo "=================================================="

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# =========================================================
# ENABLE AUTO-COMPLETION
# =========================================================

echo "=================================================="
echo " Configuring Auto Completion"
echo "=================================================="

terraform -install-autocomplete || true

echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'source <(helm completion bash)' >> ~/.bashrc
echo 'source <(eksctl completion bash)' >> ~/.bashrc

source ~/.bashrc || true

# =========================================================
# VERIFY INSTALLATIONS
# =========================================================

echo "=================================================="
echo " Installed Versions"
echo "=================================================="

echo ""
echo "Terraform Version:"
terraform version

echo ""
echo "AWS CLI Version:"
aws --version

echo ""
echo "kubectl Version:"
kubectl version --client

echo ""
echo "eksctl Version:"
eksctl version

echo ""
echo "Helm Version:"
helm version

echo ""
echo "=================================================="
echo " ALL TOOLS INSTALLED SUCCESSFULLY"
echo "=================================================="
