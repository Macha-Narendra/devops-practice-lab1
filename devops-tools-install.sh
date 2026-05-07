#!/bin/bash

# =========================================================
# DevOps Tools Auto Installer for Ubuntu 24.04 LTS
# Installs:
#   - Terraform
#   - AWS CLI v2
#   - kubectl
#   - eksctl
#   - Helm
#
# Author: Narendra DevOps Lab
# =========================================================

set -e

echo "=================================================="
echo " Updating Ubuntu Packages"
echo "=================================================="

sudo apt update -y
sudo apt upgrade -y

echo "=================================================="
echo " Installing Required Dependencies"
echo "=================================================="

sudo apt install -y \
    curl \
    unzip \
    wget \
    apt-transport-https \
    gnupg \
    software-properties-common \
    ca-certificates \
    lsb-release \
    bash-completion

# =========================================================
# TERRAFORM INSTALLATION
# =========================================================

echo "=================================================="
echo " Installing Terraform"
echo "=================================================="

curl -fsSL https://apt.releases.hashicorp.com/gpg | \
sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo \
"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update -y
sudo apt install -y terraform

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

curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

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

rm eksctl_${PLATFORM}.tar.gz

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
