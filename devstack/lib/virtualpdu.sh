#!/bin/bash
IRONIC_VPDU_CONFIG_FILE=${IRONIC_VPDU_CONFIG_FILE:-$HOME/.vpdu/virtualpdu.conf}

GITREPO["virtualpdu"]=${VIRTUALPDU_REPO:-${GIT_BASE}/openstack/virtualpdu.git}
GITBRANCH["virtualpdu"]=${VIRTUALPDU_BRANCH:-master}
GITDIR["virtualpdu"]=$DEST/virtualpdu

function install_virtualpdu {
    if use_library_from_git "virtualpdu"; then
        git_clone_by_name "virtualpdu"
        setup_dev_lib "virtualpdu"
    else
        pip_install "virtualpdu"
    fi
}

function configure_virtualpdu {
    mkdir -p $(dirname $IRONIC_VPDU_CONFIG_FILE)

    iniset $IRONIC_VPDU_CONFIG_FILE PDU ports ${IRONIC_VPDU_PORTS}
    iniset $IRONIC_VPDU_CONFIG_FILE global debug True
    iniset $IRONIC_VPDU_CONFIG_FILE global libvirt_uri "qemu:///system"
    iniset $IRONIC_VPDU_CONFIG_FILE PDU listen_address ${HOST_IP}
    iniset $IRONIC_VPDU_CONFIG_FILE PDU listen_port ${IRONIC_VPDU_LISTEN_PORT}
    iniset $IRONIC_VPDU_CONFIG_FILE PDU community ${IRONIC_VPDU_COMMUNITY}
    iniset $IRONIC_VPDU_CONFIG_FILE PDU outlet_default_state "OFF"
}

function start_virtualpdu {
    run_process ir-vpdu "virtualpdu $IRONIC_VPDU_CONFIG_FILE" libvirtd
}

function stop_virtualpdu {
    stop_process ir-vpdu
}
