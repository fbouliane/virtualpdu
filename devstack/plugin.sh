#!/bin/bash
source $DEST/virtualpdu/devstack/lib/virtualpdu.sh

if is_service_enabled ir-vpdu; then
    if [[ "$1" == "stack" && "$2" == "install" ]]; then
        echo_summary "Installing VirtualPDU"
        install_virtualpdu
    elif [[ "$1" == "stack" && "$2" == "post-config" ]]; then
        echo_summary "Configuring VirtualPDU"
        configure_virtualpdu
        echo_summary "Initializing VirtualPDU"
        start_virtualpdu
    fi
    if [[ "$1" == "unstack" ]]; then
        stop_virtualpdu
    fi
fi
