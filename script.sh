#!/bin/bash

function get_latest_github_release {
	curl -s https://api.github.com/repos/$1/$2/releases/latest | grep -oP '"tag_name": "[v]\K(.*)(?=")'
}

INSTALL_DIR='/usr/bin'
REGEX="^PATH=.*\K$INSTALL_DIR(?=.*)"
if [[ $(env | grep -oP $REGEX) != $INSTALL_DIR ]]; then
   echo "Looks like your install directory $INSTALL_DIR is not in your PATH. Make sure you export it"; fi

INSTALLED_TERRAFORM_VERSION=$(terraform --version | grep -Poie '\d+.\d+.\d+')

LATEST_TERRAFORM_RELEASE=$(get_latest_github_release hashicorp terraform)

if [[ ${LATEST_TERRAFORM_RELEASE} != ${INSTALLED_TERRAFORM_VERSION} ]]; then
   echo "Installing Terraform ${LATEST_RELEASE}..."
   wget https://releases.hashicorp.com/terraform/${LATEST_TERRAFORM_RELEASE}/terraform_${LATEST_TERRAFORM_RELEASE}_linux_amd64.zip
   unzip -o terraform_${LATEST_TERRAFORM_RELEASE}_linux_amd64.zip
   rm terraform_${LATEST_TERRAFORM_RELEASE}_linux_amd64.zip
   sudo install terraform ${INSTALL_DIR}/terraform
   rm -rf terraform
else
   echo "Nothing done. Latest Terraform already installed."
fi
