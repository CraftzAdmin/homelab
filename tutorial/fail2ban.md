# Instalação e Configuração do Fail2Ban no Proxmox VE

Fonte Oficial: [https://pve.proxmox.com/wiki/Fail2ban](https://pve.proxmox.com/wiki/Fail2ban)

Fonte: [https://forum.proxmox.com/threads/fail2ban-installation-not-running.145419/](https://forum.proxmox.com/threads/fail2ban-installation-not-running.145419/)

---


O **Fail2Ban** é uma ferramenta de segurança poderosa que protege servidores contra ataques de força bruta. Ele monitora os arquivos de log dos serviços e, ao detectar tentativas repetidas de falhas de autenticação, bloqueia automaticamente o endereço IP suspeito por um determinado período de tempo. Isso previne acessos não autorizados, reforçando a segurança do seu servidor. No **Proxmox VE**, o Fail2Ban é essencial para proteger tanto a interface web quanto o acesso SSH e outros serviços críticos.

### Como o Fail2Ban Funciona?

O Fail2Ban funciona com base em “**jails**”, que são regras específicas de monitoramento e resposta para determinados serviços, como **SSH**, **Nginx**, e **Proxmox VE API**. Cada jail define:

- **Quais logs** monitorar.
- **O que procurar** nesses logs (padrões de falhas de login, por exemplo).
- **Quais ações** tomar quando um comportamento suspeito for detectado (como banir um IP temporariamente).

Um **jail** consiste em três partes principais:

1. **Logpath**: Define o arquivo de log que será monitorado.
2. **Failregex**: Expressões regulares que determinam o padrão de comportamento suspeito a ser monitorado (por exemplo, várias tentativas de login falhas).
3. **Ação**: O que fazer quando o comportamento suspeito for detectado, como banir um IP ou enviar um alerta.

---

### Passo a Passo: Instalando e Configurando o Fail2Ban no Proxmox VE

### A. **Através de um Script**

```bash
bash -c "$(wget -qLO - https://raw.githubusercontent.com/CraftzAdmin/homelab/main/scripts/fail2ban_setup.sh)"
```

### 1. **Instalar o Fail2Ban Manualmente**

Após instalar o Proxmox VE, o primeiro passo é abrir o **Shell** via **SSH** ou pela **interface web do Proxmox**. Para instalar o **Fail2Ban**, execute os comandos como **root**:

```bash
apt update
apt install fail2ban
```

Este comando atualizará a lista de pacotes e instalará o Fail2Ban no seu sistema.

---

### 2. **Configurar o Fail2Ban**

Para evitar que futuras atualizações sobrescrevam suas configurações personalizadas, você deve usar o arquivo `/etc/fail2ban/jail.local`, que tem precedência sobre o **jail.conf** padrão.

- Para usar o **jail.conf** como modelo, copie-o para **jail.local**:

```bash
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

### 2. Editando o Arquivo `/etc/fail2ban/jail.local` Usando o Nano

Para configurar o **Fail2Ban**, você precisará editar o arquivo `/etc/fail2ban/jail.local` que acabamos de criar, para adicionar suas configurações específicas. Aqui, vamos usar o **Nano**, um editor de texto simples e fácil de usar, que já vem instalado na maioria das distribuições Linux. Siga os passos abaixo:

### a. Abra o arquivo `jail.local` com o Nano

No terminal, execute o seguinte comando para abrir o arquivo com o Nano:

```bash
nano /etc/fail2ban/jail.local
```

O comando acima abre o arquivo **jail.local** no editor **Nano**. 

Ao abrir o Nano, você verá o conteúdo do arquivo **jail.local**. Use as setas do teclado para navegar pelo arquivo. **Você pode adicionar suas configurações na parte inferior** do arquivo ou modificar as existentes.

### b. Adicione as configurações do Fail2Ban para o Proxmox e SSH

Agora, você pode adicionar os blocos de configuração para o **Proxmox** e **SSH**. Simplesmente digite ou cole o seguinte conteúdo no arquivo:

```bash
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
```

Isso configura o Fail2Ban para monitorar as tentativas de login no Proxmox e no SSH, bloqueando IPs após três tentativas falhas em um intervalo de 2 dias, com um banimento de 1 hora.

A configuração `backend = systemd` no arquivo de configuração do **Fail2Ban** define o mecanismo (ou "backend") que o Fail2Ban vai usar para acessar e ler os logs do sistema.

Especificamente, ao configurar o backend como **systemd**, o Fail2Ban vai monitorar os logs gerados e gerenciados pelo **systemd-journald**, o sistema de gerenciamento de logs padrão em distribuições Linux modernas que utilizam o **systemd**. Em vez de ler diretamente arquivos de log como `/var/log/auth.log` ou outros logs de texto tradicionais, o Fail2Ban acessa os logs diretamente do **journal** do **systemd**.

### c. Salvar e sair do Nano

Após fazer as alterações, você precisará salvar o arquivo e sair do **Nano**. Siga os passos abaixo:

- Pressione **CTRL + O** para salvar o arquivo. O Nano pedirá que você confirme o nome do arquivo (nesse caso, **/etc/fail2ban/jail.local**). Simplesmente pressione **Enter**.
- Para sair do Nano, pressione **CTRL + X**.
  

---

## **3.Explicando o conceito dos blocos [proxmox] e [sshd]**

<aside>
⚙

**[proxmox]**: Este bloco configura o Fail2Ban para monitorar a interface web do Proxmox. Ele observa o arquivo de log do **systemd** para detectar tentativas falhas de login.

</aside>

- **port**: Define as portas que serão monitoradas, como **8006** para a interface web do Proxmox.
- **filter**: Usa um filtro personalizado (explicado mais adiante).
- **maxretry**: Define o número máximo de tentativas falhas permitidas antes de banir o IP.
- **findtime**: Tempo durante o qual essas tentativas falhas são monitoradas (2 dias, neste exemplo).
- **bantime**: Duração do banimento (1 hora)

<aside>
⚙

**[sshd]**: Este bloco configura o Fail2Ban para monitorar o serviço **SSH**. É importante proteger o SSH, pois é uma das principais portas de entrada para administradores.

</aside>

- **logpath**: Aponta para o arquivo de log do SSH, que o Fail2Ban usará para identificar tentativas falhas de login.

Essas configurações podem ser ajustadas conforme suas necessidades. Se você quiser proteger outros serviços, como o **Nginx**, você pode adicionar mais jails ao arquivo **jail.local**, da seguinte forma:

```bash
[nginx-http-auth]
enabled = true
port    = http,https
filter  = nginx-http-auth
logpath = /var/log/nginx/error.log
maxretry = 3
```

Esse exemplo monitora tentativas de autenticação HTTP no Nginx e bane IPs após três falhas.

---

## **4. Criar o Filtro do Fail2Ban para o Proxmox**

Agora, vamos criar um filtro específico para o Proxmox. Esse filtro define o padrão de comportamento que o Fail2Ban deve monitorar nos logs do Proxmox.

Crie o arquivo `/etc/fail2ban/filter.d/proxmox.conf` :

```powershell
nano /etc/fail2ban/filter.d/proxmox.conf
```

Agora insira o conteúdo: 

```bash
[Definition]
failregex = pvedaemon\[.*authentication failure; rhost=<HOST> user=.* msg=.*
ignoreregex =
journalmatch = _SYSTEMD_UNIT=pvedaemon.service
```

### Explicação do Código:

### `[Definition]`

Esta seção define as regras que o **Fail2Ban** utilizará para detectar padrões de comportamento malicioso nos logs do sistema.

### `failregex = pvedaemon\[.*authentication failure; rhost=<HOST> user=.* msg=.*`

- **failregex** (fail regular expression) define uma **expressão regular** que o **Fail2Ban** usará para procurar padrões específicos nos logs que correspondem a uma tentativa de login falha.
- Neste caso, a expressão está configurada para detectar falhas de autenticação no log do serviço **pvedaemon**, que é o daemon responsável pela interface web e gerenciamento no **Proxmox VE**.
- **rhost=<HOST>**: Este é um marcador que será substituído pelo endereço IP de origem que fez a tentativa de login.
- A expressão regular `authentication failure; rhost=<HOST> user=.* msg=.*` captura as mensagens de falha de autenticação que incluem informações sobre o host (IP) e o usuário que falhou na tentativa de login.

### `ignoreregex =`

- **ignoreregex** é usado para definir padrões que devem ser ignorados. No caso deste código, está vazio, o que significa que não há padrões sendo ignorados. Ou seja, ele vai processar todas as falhas de autenticação correspondentes ao **failregex** sem excluir nenhum evento.

### `journalmatch = _SYSTEMD_UNIT=pvedaemon.service`

- **journalmatch** define o filtro específico usado quando o **systemd-journald** é o backend (como definido em `backend = systemd`).
- Essa linha especifica que o **Fail2Ban** deve monitorar apenas as entradas de log associadas ao **pvedaemon.service** (a unidade do **systemd** que gerencia o Proxmox).

### O Que Esse Código Faz?

Esse filtro instrui o **Fail2Ban** a procurar nos logs do **systemd-journald** por falhas de autenticação no serviço **pvedaemon** do Proxmox. Se o padrão de falha for detectado (com base no **failregex**), o **Fail2Ban** tomará as ações configuradas no arquivo `jail.local` para esse serviço, como banir o IP que causou a falha de login.

---

### **5.Reiniciar o Fail2Ban para Aplicar as Configurações**

Após fazer todas as alterações, é necessário reiniciar o **Fail2Ban** para aplicar as novas regras:

```bash
systemctl restart fail2ban
```

Com isso, o Fail2Ban começará a monitorar as tentativas de login no Proxmox e SSH, e bloqueará automaticamente IPs maliciosos.

---

### 6. **Testar a Configuração**

Você pode testar sua configuração tentando fazer login com uma senha ou nome de usuário incorreto na interface web do Proxmox. Depois, execute o seguinte comando para verificar se o Fail2Ban detectou as tentativas falhas:

```powershell
fail2ban-client -v status
```

Se a configuração estiver correta, você verá algo como **o print abaixo, sem nenhum erro:**

![Fail2Ban Image](https://raw.githubusercontent.com/CraftzAdmin/homelab/c7e9b2fbdbd9514cf582597ba0d037c66a654c36/images/fail2ban.png)


---

### 7. **Desbloquear-se Caso Tenha Sido Banido**

Se você acidentalmente bloquear seu próprio IP, pode desbloqueá-lo manualmente com o seguinte comando:

```bash
fail2ban-client unban <IP>
```

Substitua **<IP>** pelo seu endereço de IP.

### Adicionando Jails para Outros Serviços

Além do Proxmox e SSH, o **Fail2Ban** pode proteger vários outros serviços. Basta adicionar um novo **jail** no arquivo `/etc/fail2ban/jail.local`. Por exemplo, para proteger o **Nginx**, você pode usar a configuração do exemplo anterior.

