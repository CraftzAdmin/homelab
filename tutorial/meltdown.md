# **Desabilitar as Mitigações Spectre/Meltdown**

### O que são as mitigações Spectre/Meltdown?

**Spectre e Meltdown são vulnerabilidades de hardware que afetam processadores modernos e permitem que um invasor acesse dados protegidos. As mitigações são implementadas no sistema operacional para proteger o sistema, mas, em contrapartida, podem impactar o desempenho.** Desabilitar essas mitigações pode melhorar o desempenho do sistema, mas ao custo de expor a máquina a potenciais vulnerabilidades.

Este patch para **Spectre/Meltdown** **não altera a mitigação das vulnerabilidades**, mas serve especificamente para remover as mensagens de notificação que aparecem durante o boot de servidores com processadores Xeon, evitando alertas desnecessários ao iniciar o sistema.



### **Passo a Passo para Desabilitar as Mitigações Spectre/Meltdown**

### **1. Exibir as Configurações Atuais**

Antes de desabilitar as mitigações, você pode verificar a configuração atual no arquivo `/etc/kernel/cmdline`.

1.  **Verificar o conteúdo atual de `/etc/kernel/cmdline`**:
    
    ```bash
    cat /etc/kernel/cmdline
    ```
    
    -   Isso exibe as opções de linha de comando atuais passadas para o kernel.

### **2. Fazer Backup do Arquivo**

**É importante criar um backup do arquivo** `/etc/kernel/cmdline` para poder reverter as mudanças posteriormente.

1.  **Criar um backup**:
    
    ```bash
    cp /etc/kernel/cmdline /etc/kernel/cmdline.bak
    ```
    

### **3. Verificar se as Mitigações Já Estão Desativadas**

1.  **Verificar se `mitigations=off` já está presente**:
    
    ```bash
    grep 'mitigations=off' /etc/kernel/cmdline
    ```
    -   Se a linha já existir, significa que as mitigações estão desativadas. Caso contrário, siga para o próximo passo.

### **4. Desativar as Mitigações**

Para desativar as mitigações, você precisa adicionar a opção `mitigations=off` no final da linha do arquivo `/etc/kernel/cmdline`.

1.  **Adicionar `mitigations=off` ao final da linha**:
    
    ```bash
    sed -i 's|boot=zfs.*|& mitigations=off|' /etc/kernel/cmdline
    ```
    
    -   Esse comando procura pela configuração atual e adiciona `mitigations=off` ao final da linha, preservando as outras opções que já estavam configuradas.

### **5. Modificar o Arquivo GRUB**

Além de alterar o arquivo `/etc/kernel/cmdline`, também é necessário modificar o GRUB para garantir que as mitigações sejam desativadas em todas as inicializações.

1.  **Editar o arquivo `/etc/default/grub`**:
    
    ```bash
    nano /etc/default/grub
    ```
    
2.  **Adicionar a opção `mitigations=off` ao final da linha `GRUB_CMDLINE_LINUX_DEFAULT`**:
    
    -   **Para Intel:**
        
        ```bash
        GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt mitigations=off"
        ```
        
    -   **Para AMD:**
        
        ```bash
        GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on iommu=pt mitigations=off"
        ```
        
3.  **Atualizar o GRUB**:
    
    -   Após a modificação, atualize o GRUB com:
    
    ```bash
    update-grub
    ```
    
4.  **Atualizar as Configurações de Boot**:
    
    -   Para aplicar as mudanças, execute:
    
    ```bash
    proxmox-boot-tool refresh
    ```
    

### **6. Reiniciar o Sistema**

Após realizar as modificações, é necessário reiniciar o sistema para aplicar as mudanças.

1.  **Reiniciar o Proxmox**:
    
    ```bash
    reboot
    ```
  ### Para verificar se as linhas de mitigação foram aplicadas corretamente, você pode usar o seguinte comando no shell:

```bash
dmesg | grep -e mitigation
```
```bash
[    0.000000] Command line: initrd=\EFI\proxmox\6.8.12-2-pve\initrd.img-6.8.12-2-pve root=ZFS=rpool/ROOT/pve-1 boot=zfs mitigations=off
[    0.084090] Kernel command line: initrd=\EFI\proxmox\6.8.12-2-pve\initrd.img-6.8.12-2-pve root=ZFS=rpool/ROOT/pve-1 boot=zfs mitigations=off

```

## Se essas linhas estiverem presentes, o parâmetro `mitigations=off` foi aplicado corretamente. 

----------

## **Reverter as Mudanças**

Caso você queira reverter as mudanças e ativar novamente as mitigações de Spectre/Meltdown, siga os passos abaixo:

1.  **Restaurar o backup do arquivo `/etc/kernel/cmdline`**:
    
    ```console
    cp /etc/kernel/cmdline.bak /etc/kernel/cmdline
    ```
    
2.  **Restaurar o arquivo GRUB**:
    
    -   Edite novamente o arquivo `/etc/default/grub` para remover `mitigations=off` e voltar à configuração original:
    
    ```console
    GRUB_CMDLINE_LINUX_DEFAULT="quiet"
    ```
    
3.  **Atualizar o GRUB e o Boot**:
    
    ```bash
    update-grub
    proxmox-boot-tool refresh
    ```
    
4.  **Reiniciar o Sistema**:
    
    ```bash
    reboot
    ```
### Para verificar se a remoção de mitigação foram aplicadas corretamente, você pode usar o seguinte comando no shell:

```bash
dmesg | grep -e mitigation
```

### Se nenhuma resultado retornar, o parâmetro `mitigations=off` foi aplicado corretamente. 

---
