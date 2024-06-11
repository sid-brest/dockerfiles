#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to print messages
print_message() {
  echo "#####################################"
  echo "# $1"
  echo "#####################################"
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Update and upgrade packages
print_message "Updating and upgrading system packages"
apt update && apt upgrade -y

# Install Python 3 and pip
if command_exists python3 && command_exists pip3; then
  print_message "Python 3 and pip3 already installed"
else
  print_message "Installing Python 3 and pip"
  apt install -y python3 python3-pip
fi

# Install AWS CLI
if command_exists aws; then
  print_message "AWS CLI already installed"
else
  print_message "Installing AWS CLI"
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install
  # Optionally remove the installation files
  rm -rf awscliv2.zip aws
fi

# Add NodeSource repository and install Node.js and npm
if command_exists node && command_exists npm; then
  print_message "Node.js and npm already installed"
else
  print_message "Installing Node.js and npm"
  curl -sL https://deb.nodesource.com/setup_20.x | bash -
  apt install -y nodejs
  npm install -g npm
fi

# Install AWS CDK
if command_exists cdk; then
  print_message "AWS CDK already installed"
else
  print_message "Installing AWS CDK"
  npm install -g aws-cdk
fi

# Install additional utilities: git, tree, curl, nano, unzip
print_message "Installing additional utilities: git, tree, curl, nano, unzip"
apt install -y git tree curl nano unzip

# Verify installations
print_message "Verifying installations"
python3 --version
pip3 --version
aws --version
node --version
npm --version
cdk --version
git --version
tree --version
curl --version
nano --version
unzip -v

# Configure AWS CLI if AWS credentials are provided as arguments
if [ ! -z "$1" ] && [ ! -z "$2" ]; then
  print_message "Configuring AWS CLI"
  aws configure set aws_access_key_id $1
  aws configure set aws_secret_access_key $2
  aws configure set default.region ${3:-us-east-1}
  aws configure set default.output ${4:-json}
  aws sts get-caller-identity
fi

print_message "Setup completed successfully!"