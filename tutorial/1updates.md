**1\. Atualizar e Fazer Upgrade**
---------------------------------

Esta função é usada para manter o Proxmox atualizado, garantindo que todas as atualizações de pacotes e segurança estejam instaladas.

Atualizar o sistema Proxmox VE regularmente é crucial para garantir que você tenha as correções de segurança mais recentes, as melhorias de desempenho e a estabilidade que novas versões de pacotes podem oferecer. Além disso, atualizações também podem corrigir bugs.

<hr>

### Passo a passo:

1.  **Abra o terminal do Proxmox**:

    -   Você pode acessar o terminal diretamente no Proxmox VE usando o Console ou através de uma conexão SSH.
2.  **Atualize a lista de pacotes disponíveis**:

    -   O comando abaixo atualiza a lista de pacotes que estão disponíveis para serem instalados ou atualizados. Isso significa que ele irá consultar os servidores de pacotes para verificar o que há de novo. <p></p>

    ```console

     apt update

    ```

4.  **Atualize os pacotes instalados**:

    -   Após atualizar a lista de pacotes, você pode atualizar os pacotes instalados em seu sistema com o seguinte comando:<p></p>
      

    ```console
     apt upgrade -y
    ```

    -   O comando `apt upgrade` atualiza todos os pacotes instalados no sistema para suas versões mais recentes. A opção `y` faz com que o sistema responda "sim" automaticamente para todas as perguntas que aparecerem, permitindo que o processo de atualização continue sem interrupções.
6.  **Reinicie o Proxmox (se necessário)**:

    -   Se, ao final da atualização, o terminal sugerir que o sistema seja reiniciado, você pode usar o comando:<p></p>

    ```console

     reboot

    ```
 **Atenção**: Algumas atualizações, especialmente as que envolvem o kernel ou outros componentes críticos do sistema, exigem que o sistema seja reiniciado para que as mudanças tenham efeito.

Atualizar seu Proxmox VE garante que você tenha as melhorias de segurança e desempenho mais recentes, além de correções de bugs conhecidos. No entanto, é importante observar que, se você estiver executando máquinas virtuais críticas, é recomendável fazer atualizações durante períodos de manutenção planejada para evitar interrupções.

Além de realizar a atualização, é crucial que os repositórios estejam configurados corretamente, seja para usuários com licença **Enterprise** ou para aqueles sem assinatura (**No-Subscription**). Se os repositórios não estiverem configurados de acordo com sua licença (e veremos como fazer isso mais adiante), a primeira atualização irá apenas baixar os pacotes do **Debian**, sem incluir as atualizações específicas do Proxmox VE. Portanto, certificar-se de que os repositórios estão adequados à sua licença é fundamental para garantir que o sistema receba todas as atualizações necessárias.
