## **3. Listar e Modificar Repositórios**

Os **repositórios** no Proxmox são as fontes de onde o sistema obtém pacotes e atualizações. Durante a instalação, o Proxmox é configurado para usar repositórios padrão, como o **Enterprise** (que requer uma assinatura) ou o **No-Subscription** (gratuito, mas com menos garantias de estabilidade). Saber listar e modificar os repositórios é essencial para garantir que o Proxmox esteja utilizando fontes confiáveis para pacotes e atualizações.

-   **Enterprise (Pago)**: Oferece pacotes estáveis e testados com suporte comercial.
    
-   **No-Subscription (Gratuito)**: Permite atualizações sem assinatura, mas pode ser menos estável.
    
 
    ---
    ### **1. Como Listar os Repositórios Ativos**
    
    1.  **Acesse o terminal do Proxmox**:
    
    -   Você pode acessar o terminal diretamente via console ou através de uma conexão SSH.
    
    2.  **Listar os repositórios principais**:
    
    -   O arquivo principal que contém os repositórios no Proxmox é o `/etc/apt/sources.list`. Para verificar quais repositórios estão ativos, use o seguinte comando:<p></p>
    
    ```console	
    cat /etc/apt/sources.list
    ```
    
    3.  **Verificar o repositório Enterprise (se aplicável)**:
    
    -   Caso você tenha uma assinatura paga, ou para verificar se o repositório **Enterprise** está configurado, você pode listar o arquivo específico onde ele está definido:<p></p>
    
    ```console
    cat /etc/apt/sources.list.d/pve-enterprise.list
    ```
    
    -   O repositório **Enterprise** oferece pacotes testados e estáveis, mas requer uma assinatura. Se você não tiver a assinatura, essa linha pode estar comentada com um `#`, indicando que está desativado.
    
    4.  **Entendendo as linhas de repositórios**:
    
    -   Aqui está um exemplo de uma linha de repositório:<p></p>
        
        ```console
        deb <http://download.proxmox.com/debian/pve> buster pve-no-subscription
        ```
        
    -   A palavra **`deb`** indica que é um repositório de pacotes Debian. A URL aponta para o servidor onde os pacotes serão baixados. A palavra **`pve-no-subscription`** **indica que esse é o repositório gratuito, sem assinatura.**
        
    
    1.  **Comando útil para verificar todos os repositórios ativos**:
    
    -   O comando `apt-cache policy` também pode ser utilizado para listar os repositórios ativos e as versões dos pacotes disponíveis:<p></p>
    
    ```console
    apt-cache policy
    ```
    ---
   
	### **2. Como Modificar os Repositórios**   
    
	   1.  **Acesse o arquivo principal de repositórios**:<p></p>
    
    -   O arquivo principal que controla os repositórios é o `/etc/apt/sources.list`. Para modificar os repositórios, use o comando:<p></p>
    
    ```console
    nano /etc/apt/sources.list
    ```
    

	2.  **Modificar para o repositório Enterprise (opcional)**:<p></p>

	-   Se você tem uma assinatura do Proxmox, pode alterar ou adicionar o repositório **Enterprise**. Insira a seguinte linha no arquivo `/etc/apt/sources.list.d/pve-enterprise.list`:<p></p>

	```console
	nano /etc/apt/sources.list.d/pve-enterprise.list

		Insira a linha: 
		deb <https://enterprise.proxmox.com/debian/pve> buster pve-enterprise
	```

	3.  **Desativar o repositório Enterprise (se não houver assinatura)**:<p></p>

	-   Caso o repositório **Enterprise** esteja ativo, mas você não tenha uma assinatura, isso pode gerar erros de atualização. Para desativá-lo, comente a linha adicionando um `#` no início:<p></p>
	
	```console
	nano /etc/apt/sources.list.d/pve-enterprise.list

	Comente a linha:
	#deb <https://enterprise.proxmox.com/debian/pve> buster pve-enterprise
	```
	4.  **Alternar para o repositório No-Subscription**:

	-   Se você preferir usar o repositório gratuito **No-Subscription**, modifique ou adicione a seguinte linha no arquivo `/etc/apt/sources.list`:<p></p>

		```console
		nano /etc/apt/sources.list

		Acrescente a linha: 
		deb <http://download.proxmox.com/debian/pve> buster pve-no-subscription
		```

	5.  **Salve e saia do editor**:<p></p>

	-   Depois de fazer as modificações nos repositórios, pressione `CTRL + O` para salvar e `CTRL + X` para sair do editor. Ou use `CTRL + X` e confirme as alterações .<p></p>

	6.  **Atualize a lista de pacotes**:<p></p>

	-   Para que o Proxmox reconheça as mudanças nos repositórios, atualize a lista de pacotes com o comando abaixo. Este comando força o sistema a buscar as listas de pacotes mais recentes nos novos repositórios configurados.<p></p>

		```console
		apt update
		```

	7.  **Verifique se os repositórios estão funcionando corretamente**:<p></p>
    
    -   Use o comando `apt-cache policy` para garantir que os novos repositórios estão ativos:
    
    ```console
    apt-cache policy
    ```
    
 ---   
   ### 3. Impacto da Modificação dos Repositórios
    
   Modificar os repositórios é essencial para garantir que o Proxmox VE receba pacotes e atualizações confiáveis. O repositório **Enterprise** é ideal para ambientes de produção que necessitam de estabilidade e suporte contínuo. O **No-Subscription** é mais adequado para ambientes de teste ou para usuários que não têm uma assinatura ativa, mas ainda querem receber atualizações.
 
   ### Tabela de comandos úteis para listar e modificar repositórios:

| ***Comando*** |***Descrição*** |
|--|--|
|`cat /etc/apt/sources.list`|Exibe o conteúdo dos repositórios principais.|
| `cat /etc/apt/sources.list.d/pve-enterprise.list` | Exibe o repositório empresarial, se configurado. |
| `cat /etc/apt/sources.list.d/pve-enterprise.list`| Exibe o repositório empresarial, se configurado. |
|  `nano /etc/apt/sources.list` | Edita os repositórios principais no Proxmox. |
|  `apt update` |Atualiza a lista de pacotes após modificar os repositórios.  |
|`apt-cache policy`  | Exibe os pacotes disponíveis e seus repositórios correspondentes.|
|||

### **3.a - Guia Passos para Configurar Repositórios no Proxmox**

| **Cenário**                        | **Passo 1**                                           | **Passo 2**                        | **Passo 3**                                  | **Passo 4**                                  |
|------------------------------------|------------------------------------------------------|------------------------------------|---------------------------------------------|---------------------------------------------|
| **Usuários sem assinatura (No-Subscription)** | Verificar se o repositório Enterprise está desativado. | Ativar o repositório "No-Subscription". | Atualizar a lista de pacotes.               | Verificar se os repositórios estão funcionando. |
| **Usuários com assinatura Enterprise** | Verificar se o repositório Enterprise está ativo.     | Ativar o repositório Enterprise.   | Desativar o repositório "No-Subscription" (opcional). | Atualizar a lista de pacotes. Verificar se os repositórios estão funcionando. |

---
