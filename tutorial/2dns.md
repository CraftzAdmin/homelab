**2\. Modificar a Configuração do DNS**
---------------------------------------

No Proxmox, a configuração de DNS é essencial para garantir que o sistema possa se comunicar corretamente com a internet, acessar repositórios de pacotes, receber atualizações e conectar-se a outros serviços.

Normalmente, durante a **configuração inicial do Proxmox**, um DNS padrão é obtido automaticamente do **gateway da rede**. No entanto, em muitos casos, você pode querer alterar o DNS para um mais rápido ou confiável, como o **Cloudflare**, **Google DNS** ou **OpenDNS**, que podem melhorar o desempenho de rede e a segurança.

---

No meu script, foram listadas várias opções de servidores DNS:

1.  **Cloudflare (1.1.1.1, 1.0.0.1)**:

    -   **Vantagens**: Alta velocidade e foco em privacidade.
    -   **Ideal para quem deseja uma resposta rápida e proteção de dados pessoais**.
2.  **Cloudflare com Proteção contra Malware (1.1.1.2, 1.0.0.2)**:

    -   **Vantagens**: Bloqueia automaticamente sites maliciosos.
    -   **Ideal para ambientes que precisam de maior proteção contra malware**.
3.  **Cloudflare com Proteção contra Malware e Conteúdo Adulto (1.1.1.3, 1.0.0.3)**:

    -   **Vantagens**: Além de bloquear malware, bloqueia também sites com conteúdo adulto.
    -   **Ideal para ambientes familiares ou profissionais que necessitam de filtros adicionais**.
4.  **Google DNS (8.8.8.8, 8.8.4.4)**:

    -   **Vantagens**: Alta disponibilidade e confiabilidade.
    -   **Ótimo para usuários que desejam uma solução globalmente reconhecida**.

    ### 2.a - Como Modificar a Configuração do DNS Manualmente:

    1.  **Verificar a configuração de DNS atual**:

        -   Antes de modificar, você pode verificar qual DNS o Proxmox está usando atualmente com o seguinte comando:<p></p>

     ```console
     cat /etc/resolv.conf
      ```

    2.  **Acesse o terminal do Proxmox**:

        -   Conecte-se ao Proxmox via console diretamente ou através de SSH.
    3.  **Abra o arquivo de configuração do DNS**:

        -   No Proxmox, **o DNS é configurado no arquivo** `/etc/resolv.conf`. O `nano` é um editor de texto que você pode usar para modificar arquivos de configuração diretamente no terminal.

        Para editar o arquivo e modificar os servidores DNS, use o seguinte comando:<p></p>

    ```console
    nano /etc/resolv.conf
    ```

    1.  **Modifique ou adicione os servidores DNS**:
    -   No arquivo `/etc/resolv.conf`, você verá linhas que indicam os servidores DNS atuais:<p></p>

     ```console
     nameserver 192.168.1.1
     ```

    Isso mostra que o DNS está apontando para o gateway (192.168.1.1). Esse DNS pode ser o obtido via DHCP, o que não necessariamente é o mais rápido ou confiável.

    -   Substitua ou adicione servidores DNS de sua escolha. Aqui estão algumas opções recomendadas:

    **Para usar o DNS da Cloudflare (1.1.1.1 e 1.0.0.1)**:<p></p>


    ```console
    nameserver 1.1.1.1
    nameserver 1.0.0.1
    ```

    **Para usar o Cloudflare com proteção contra malware (1.1.1.2 e 1.0.0.2)**:<p></p>


    ```console
    nameserver 1.1.1.2
    nameserver 1.0.0.2
    ```

    **Para usar o Google DNS (8.8.8.8 e 8.8.4.4)**:<p></p>


    ```console
    nameserver 8.8.8.8
    nameserver 8.8.4.4
    ```

    **Para usar o OpenDNS (208.67.222.222 e 208.67.220.220)**:<p></p>

    ```console
    nameserver 208.67.222.222
    nameserver 208.67.220.220
    ```

    -   Cada linha `nameserver` define um servidor DNS que o Proxmox utilizará para resolver nomes de domínio. Substitua ou adicione novos servidores conforme necessário.
5.  **Salve e saia do editor**:

    -   Depois de fazer as alterações, pressione `CTRL + O` para salvar o arquivo e `CTRL + X` para sair do editor `nano`. Ou use `CTRL + X` e confirme as alterações .
6.  **Teste a nova configuração de DNS**:

    -   Para verificar se as mudanças no DNS estão funcionando, use o comando `ping` para testar a resolução de nomes de domínio:<p></p>


    ```console
    ping google.com
    ```

    Se a nova configuração estiver funcionando, você verá uma resposta de ping, indicando que o Proxmox consegue resolver o nome de domínio.

### Impacto da configuração do DNS:

A escolha correta de um servidor DNS pode melhorar o desempenho do Proxmox ao acessar a internet e repositórios para atualizações de pacotes. DNSs mais rápidos como o Cloudflare ou o Google podem reduzir o tempo de resposta de serviços externos. Além disso, escolher DNSs com proteção contra malware (como o Cloudflare 1.1.1.2) pode adicionar uma camada extra de segurança, bloqueando sites maliciosos automaticamente.

### Comandos úteis para verificar a configuração de DNS no Proxmox:

-   **Verificar DNS atual**:<p></p>
  
  ```console
    cat /etc/resolv.conf
   ```

-   **Testar a resolução de nomes de domínio (ex. [google.com](http://google.com))**<p></p>

   ```console
    ping google.com
   ```

-   **Verificar o gateway padrão (DNS obtido automaticamente)**:<p></p>


  ```console
   ip route | grep default
   ```
