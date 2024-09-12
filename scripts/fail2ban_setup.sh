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
          
        Script Instalação Fail2Ban
         Por Daniel Brunod
         
EOF
}

# Função para verificar se a função [sshd] já foi comentada
function check_sshd_commented {
    if grep -q "#port    = ssh" /etc/fail2ban/jail.local; then
        echo "A seção [sshd] já foi comentada."
        return 0
    else
        echo "A seção [sshd] não foi comentada ainda."
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
        echo "A seção [proxmox] já existe e está configurada corretamente."
    else
        echo "A seção [proxmox] precisa ser configurada."
        return 1
    fi

    if grep -q "\[sshd\]" /etc/fail2ban/jail.local && grep -q "$SSHD_SECTION" /etc/fail2ban/jail.local; then
        echo "A seção [sshd] já existe e está configurada corretamente."
    else
        echo "A seção [sshd] precisa ser configurada."
        return 1
    fi

    return 0
}



function show_menu {
    echo "Bem-vindo ao script de instalação e configuração do Fail2Ban para Proxmox VE"
    echo "Escolha uma opção:"
    echo "1. Instalar Fail2Ban"
    echo "2. Configurar Fail2Ban para Proxmox e SSH"
    echo "3. Reiniciar Fail2Ban"
    echo "4. Desbloquear IP"
    echo "5. Sair"
}


while true; do
    header_info
    show_menu
    read -p "Opção: " option

    case $option in
        1)
            echo "Atualizando pacotes e instalando Fail2Ban..."
            apt update
            apt install -y fail2ban
            echo "Fail2Ban instalado com sucesso."
            ;;
        
       2)
            echo "Configurando Fail2Ban para Proxmox e SSH..."

            # Cria o arquivo jail.local se não existir e copia jail.conf como base
            if [ ! -f /etc/fail2ban/jail.local ]; then
                cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
                echo "Arquivo jail.local criado a partir de jail.conf."
            else
                echo "Arquivo jail.local já existe."
            fi

            # Verifica se a seção [sshd] já foi comentada
            if ! check_sshd_commented; then
                # Comenta as linhas específicas da seção [sshd]
                sed -i '/\[sshd\]/,/backend = %(sshd_backend)s/ s/^\([^#].*\)/#\1/' /etc/fail2ban/jail.local
                echo "As linhas específicas da seção [sshd] foram comentadas."
            fi

            # Verifica se as seções [proxmox] e [sshd] já existem e estão corretas
            if ! check_proxmox_ssh_sections; then
                echo "Adicionando as seções [proxmox] e [sshd]..."

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
                echo "Configuração de Fail2Ban para Proxmox e SSH adicionada."
            else
                echo "As seções [proxmox] e [sshd] já estão configuradas corretamente. Nenhuma ação necessária."
                exit 0
            fi

            # Cria o filtro para o Proxmox
            cat <<EOL > /etc/fail2ban/filter.d/proxmox.conf
[Definition]
failregex = pvedaemon\[.*authentication failure; rhost=<HOST> user=.* msg=.*
ignoreregex =
journalmatch = _SYSTEMD_UNIT=pvedaemon.service
EOL

            echo "Filtro para Proxmox criado."
            ;;
        
        3)
            echo "Reiniciando Fail2Ban para aplicar as configurações..."
            systemctl restart fail2ban
            echo "Fail2Ban reiniciado."
            ;;
        
        4)
            read -p "Digite o IP a ser desbloqueado: " ip
            fail2ban-client unban $ip
            echo "IP $ip desbloqueado."
            ;;
        
        5)
            echo "Saindo..."
            exit 0
            ;;
        
        *)
            echo "Opção inválida. Tente novamente."
            ;;
    esac

    # Pausa antes de voltar ao menu
    read -p "Pressione Enter para voltar ao menu principal..."
done
