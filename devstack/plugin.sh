#!/bin/bash

PLUGIN_DIR=$(realpath /opt/stack/openstack-plugin-terraform)
SERVICE_DIR=$(realpath "$PLUGIN_DIR/devstack/service")
SYSTEMD_DIR=$(realpath /etc/systemd/system)

function install_terraform {
    echo "Installing Terraform..."
    T_VERSION="1.6.0"
    T_FILE="terraform_${T_VERSION}_linux_amd64.zip"

    # Scarica terraform
    wget -q https://releases.hashicorp.com/terraform/${T_VERSION}/${T_FILE} -O /tmp/${T_FILE} || {
        echo "ERROR: Failed to download Terraform"
        exit 1
    }

    # Estrai e copia in /usr/local/bin
    sudo unzip -o /tmp/${T_FILE} -d /usr/local/bin/ || {
        echo "ERROR: Failed to unzip Terraform"
        exit 1
    }

    # Verifica installazione
    terraform version || {
        echo "ERROR: Terraform not installed correctly"
        exit 1
    }

    echo "Terraform installed successfully"
}

function configure_openstack_provider {
    echo "Configuring OpenStack provider for Terraform..."
    export OS_AUTH_URL=http://127.0.0.1/identity
    export OS_USERNAME=admin
    export OS_PASSWORD=secret
    export OS_PROJECT_NAME=admin
    export OS_USER_DOMAIN_NAME=Default
    export OS_PROJECT_DOMAIN_NAME=Default
    echo "OpenStack provider environment variables set."
}

if is_service_enabled openstack-plugin-terraform; then
    if [[ "$1" == "stack" && "$2" == "install" ]]; then
        echo "Installing Terraform Plugin"
        install_terraform
        configure_openstack_provider
    fi

    if [[ "$1" == "stack" && "$2" == "post-config" ]]; then
        echo "Post-configuring Terraform Plugin"
    fi
fi
