# **Atualização e Instalação de Microcódigo Intel e AMD**

### **O que são os Microcódigos?**

**Os microcódigos são pequenos patches aplicados diretamente aos processadores,** permitindo a correção de bugs e otimização de desempenho. **A maioria dos XEON devido a sua idade e arquitetura precisam de microcódigos para serem mais seguros.**  Isso pode ser essencial em servidores como o Proxmox, que dependem de um processamento robusto e estável. A instalação dos microcódigos mais recentes garante que o processador esteja funcionando de maneira otimizada e segura.

### **Passo a Passo para Atualização do Microcódigo**

### **1. Verificar a Revisão Atual do Microcódigo**

Antes de realizar qualquer alteração, é importante verificar a versão do microcódigo que já está instalada.

1.  **Verifique a revisão atual**:
    
    ```bash
    journalctl -k | grep -i 'microcode: Current revision:'
    ```
    
	   Isso mostrará a versão atual do microcódigo aplicada ao seu processador.

### **2. Determinar o Tipo de Processador (Intel ou AMD)**

1.  **Identificar o fabricante do processador**:
    
    ```bash
    lscpu | grep -i 'vendor id'
    ```
    
    -   **Intel** será identificado como `GenuineIntel`.
    -   **AMD** será identificado como `AuthenticAMD`.

### **3. Instalar Microcódigo para Processadores Intel**

Se você tiver um processador **Intel**, siga os passos abaixo.


1.  **Instalar a ferramenta de microcódigo Intel** (iucode-tool), caso não esteja instalada:
    
    ```bash
    apt-get install -y iucode-tool
    ```
    
2.  **Baixar o pacote de microcódigo mais recente**:
    
    -   Liste os pacotes disponíveis:
    
    ```bash
    curl -fsSL "<https://ftp.debian.org/debian/pool/non-free-firmware/i/intel-microcode/>" | grep -o 'href="[^"]*amd64.deb"' | sed 's/href="//;s/"//'
    ```
    
    -   **Instalar o pacote de microcódigo**:
    
    ```bash
    wget -q <http://ftp.debian.org/debian/pool/non-free-firmware/i/intel-microcode/><nome_do_pacote>.deb
    dpkg -i <nome_do_pacote>.deb
    ```
    
3.  **Limpar os arquivos temporários**:
    
    ```bash
    rm <nome_do_pacote>.deb
    ```
    
4.  **Reiniciar o sistema**:
    
    -   Para aplicar as mudanças, é necessário reiniciar o Proxmox:
    
    ```console
    reboot
    ```
    

### **4. Instalar Microcódigo para Processadores AMD**

Se você tiver um processador **AMD**, o processo é semelhante ao do Intel.

1.  **Baixar o pacote de microcódigo AMD**:
    
    -   Liste os pacotes disponíveis:
    
    ```bash
    curl -fsSL "<https://ftp.debian.org/debian/pool/non-free-firmware/a/amd64-microcode/>" | grep -o 'href="[^"]*amd64.deb"' | sed 's/href="//;s/"//'
    ```
    
2.  **Instalar o microcódigo AMD**:
    
    ```bash
    wget -q <https://ftp.debian.org/debian/pool/non-free-firmware/a/amd64-microcode/><nome_do_pacote>.deb
    dpkg -i <nome_do_pacote>.deb
    ```
    
3.  **Limpar os arquivos temporários**:
    
    ```bash
    rm <nome_do_pacote>.deb
    ```
    
4.  **Reiniciar o sistema**:
    
    ```bash
    reboot
    ```
    
# **Atualização e Instalação de Microcódigo Intel e AMD**

### **O que são os Microcódigos?**

**Os microcódigos são pequenos patches aplicados diretamente aos processadores,** permitindo a correção de bugs e otimização de desempenho. **A maioria dos XEON devido a sua idade e arquitetura precisam de microcódigos para serem mais seguros.**  Isso pode ser essencial em servidores como o Proxmox, que dependem de um processamento robusto e estável. A instalação dos microcódigos mais recentes garante que o processador esteja funcionando de maneira otimizada e segura.

### **Passo a Passo para Atualização do Microcódigo**

### **1. Verificar a Revisão Atual do Microcódigo**

Antes de realizar qualquer alteração, é importante verificar a versão do microcódigo que já está instalada.

1.  **Verifique a revisão atual**:
    
    ```bash
    journalctl -k | grep -i 'microcode: Current revision:'
    ```
    
	   Isso mostrará a versão atual do microcódigo aplicada ao seu processador.

### **2. Determinar o Tipo de Processador (Intel ou AMD)**

1.  **Identificar o fabricante do processador**:
    
    ```bash
    lscpu | grep -i 'vendor id'
    ```
    
    -   **Intel** será identificado como `GenuineIntel`.
    -   **AMD** será identificado como `AuthenticAMD`.

### **3. Instalar Microcódigo para Processadores Intel**

Se você tiver um processador **Intel**, siga os passos abaixo.


1.  **Instalar a ferramenta de microcódigo Intel** (iucode-tool), caso não esteja instalada:
    
    ```bash
    apt-get install -y iucode-tool
    ```
    
2.  **Baixar o pacote de microcódigo mais recente**:
    
    -   Liste os pacotes disponíveis:
    
    ```bash
    curl -fsSL "<https://ftp.debian.org/debian/pool/non-free-firmware/i/intel-microcode/>" | grep -o 'href="[^"]*amd64.deb"' | sed 's/href="//;s/"//'
    ```
    
    -   **Instalar o pacote de microcódigo**:
    
    ```bash
    wget -q <http://ftp.debian.org/debian/pool/non-free-firmware/i/intel-microcode/><nome_do_pacote>.deb
    dpkg -i <nome_do_pacote>.deb
    ```
    
3.  **Limpar os arquivos temporários**:
    
    ```bash
    rm <nome_do_pacote>.deb
    ```
    
4.  **Reiniciar o sistema**:
    
    -   Para aplicar as mudanças, é necessário reiniciar o Proxmox:
    
    ```bash
    reboot
    ```
    

### **4. Instalar Microcódigo para Processadores AMD**

Se você tiver um processador **AMD**, o processo é semelhante ao do Intel.

1.  **Baixar o pacote de microcódigo AMD**:
    
    -   Liste os pacotes disponíveis:
    
    ```bash
    curl -fsSL "<https://ftp.debian.org/debian/pool/non-free-firmware/a/amd64-microcode/>" | grep -o 'href="[^"]*amd64.deb"' | sed 's/href="//;s/"//'
    ```
    
2.  **Instalar o microcódigo AMD**:
    
    ```bash
    wget -q <https://ftp.debian.org/debian/pool/non-free-firmware/a/amd64-microcode/><nome_do_pacote>.deb
    dpkg -i <nome_do_pacote>.deb
    ```
    
3.  **Limpar os arquivos temporários**:
    
    ```bash
    rm <nome_do_pacote>.deb
    ```
    
4.  **Reiniciar o sistema**:
    
    ```bash
    reboot
    ```

# Para verificar se o microcode foi instalado com sucesso, basta digitar o seguinte comando no shell:

```bash
dmesg | grep -e micro
```

**Serão exibidas mensagens similares às seguintes, dependendo do seu processador:**

```less
[    7.135910] microcode: Current revision: 0x0b000040
[    7.136128] microcode: Updated early from: 0x0b000038
```

![Microcodes](https://github.com/CraftzAdmin/homelab/blob/aa04dd7fb183710b2f68a50ad3d33fbb37c9da35/images/microcodes.png))


Essas mensagens indicam que a atualização do microcode foi aplicada corretamente.
 

----------
