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
            fi

             # Comenta todas as linhas da seção [sshd] no arquivo jail.local
            sed -i '/\[sshd\]/,/^$/s/^\([^#]\)/#\1/' /etc/fail2ban/jail.local
            echo "Todas as linhas da seção [sshd] foram comentadas."
            
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
