#!/bin/bash

# Script para instalar e configurar Fail2Ban no Proxmox VE
# Desenvolvido por Daniel Brunod - Uso sem restrições desde que informadas as fontes.
# Copyright (c) 2024- Craftz
# Author: Daniel Brunod
# License: MIT

function header_info {
    clear
    cat <<"EOF"

 ██████╗██████╗  █████╗ ███████╗████████╗███████╗
██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝╚══███╔╝
██║     ██████╔╝███████║█████╗     ██║     ███╔╝ 
██║     ██╔══██╗██╔══██║██╔══╝     ██║    ███╔╝  
╚██████╗██║  ██║██║  ██║██║        ██║   ███████╗
 ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   ╚══════╝                                              
          
      Fail2Ban Install Script for Proxmox
            by Daniel Brunod
         
EOF
}

# Função para verificar se a função [sshd] já foi comentada
function check_sshd_commented {
    if grep -q "#port    = ssh" /etc/fail2ban/jail.local; then
        echo "The [sshd] section has already been commented out."
        return 0
    else
        echo "The [sshd] section has not been commented out yet."
        return 1
    fi
}

# Função para verificar se o conteúdo de [proxmox] e [sshd] já existe e está correto
function check_proxmox_ssh_sections {
    local PROXMOX_SECTION="[proxmox]
enabled = true
port = https,http,8006
filter = proxmox
backend = systemd
maxretry = 3
findtime = 2d
bantime = 1h"

    local SSHD_SECTION="[sshd]
port    = ssh
logpath = %(sshd_log)s
backend = systemd"

    if grep -q "\[proxmox\]" /etc/fail2ban/jail.local && grep -q "$PROXMOX_SECTION" /etc/fail2ban/jail.local; then
        echo "The [proxmox] section already exists and is configured correctly."
    else
        echo "The [proxmox] section needs to be configured."
        return 1
    fi

    if grep -q "\[sshd\]" /etc/fail2ban/jail.local && grep -q "$SSHD_SECTION" /etc/fail2ban/jail.local; then
        echo "The [sshd] section already exists and is configured correctly."
    else
        echo "The [sshd] section needs to be configured."
        return 1
    fi

    return 0
}



function show_menu {
    echo "Welcome to the Fail2Ban installation and configuration script for Proxmox VE"
    echo ""
    echo "Choose an option:"
    echo "1. Install Fail2Ban"
    echo "2. Configure Fail2Ban for Proxmox and SSH"
    echo "3. Restart Fail2Ban"
    echo "4. Unblock IP"
    echo "5. Exit"
}


while true; do
    header_info
    show_menu
    read -p "Option: " option

    case $option in
        1)
            echo "Updating packages and installing Fail2Ban..."
            apt update
            apt install -y fail2ban
            echo "Fail2Ban installed successfully."
            ;;
        
       2)
            echo "Configuring Fail2Ban for Proxmox and SSH..."

            # Cria o arquivo jail.local se não existir e copia jail.conf como base
            if [ ! -f /etc/fail2ban/jail.local ]; then
                cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
                echo "jail.local file created from jail.conf."
            else
                echo "Jail.local file already exists."
            fi

            # Verifica se a seção [sshd] já foi comentada
            if ! check_sshd_commented; then
                # Comenta as linhas específicas da seção [sshd]
                sed -i '/\[sshd\]/,/backend = %(sshd_backend)s/ s/^\([^#].*\)/#\1/' /etc/fail2ban/jail.local
                echo "Specific lines in the [sshd] section have been commented out."
            fi

            # Verifica se as seções [proxmox] e [sshd] já existem e estão corretas
            if ! check_proxmox_ssh_sections; then
                echo "Adding the [proxmox] and [sshd] sections..."

                # Adiciona a configuração para Proxmox e SSH
                cat <<EOL >> /etc/fail2ban/jail.local

[proxmox]
enabled = true
port = https,http,8006
filter = proxmox
backend = systemd
maxretry = 3
findtime = 2d
bantime = 1h

[sshd]
port    = ssh
logpath = %(sshd_log)s
backend = systemd
EOL
                echo "Fail2Ban configuration for Proxmox and SSH added."
            else
                echo "The [proxmox] and [sshd] sections are already configured correctly. No action required."
                read -p "Press Enter to return to the main menu..."
                continue
            fi

            # Cria o filtro para o Proxmox
            cat <<EOL > /etc/fail2ban/filter.d/proxmox.conf
[Definition]
failregex = pvedaemon\[.*authentication failure; rhost=<HOST> user=.* msg=.*
ignoreregex =
journalmatch = _SYSTEMD_UNIT=pvedaemon.service
EOL

            echo "Filter for Proxmox created."
            ;;
        
        3)
            echo "Restarting Fail2Ban to apply settings..."
            systemctl restart fail2ban
            echo "Fail2Ban restarted!"
            ;;
        
        4)
            read -p "Enter the IP to be unblocked: " ip
            fail2ban-client unban $ip
            echo "IP $ip unlocked."
            ;;
        
        5)
            echo "Leaving..."
            exit 0
            ;;
        
        *)
            echo "Invalid option. Please try again."
            ;;
    esac

    # Pausa antes de voltar ao menu
    read -p "Press Enter to return to the main menu..."
done
